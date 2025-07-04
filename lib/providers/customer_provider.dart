import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/session_provider.dart';
import '../providers/auth_provider.dart';

class CustomerProvider with ChangeNotifier {
  bool isLoading = false;
  List<dynamic> _customers = [];
  List<dynamic> _filteredCustomers = [];

  List<dynamic> get customers => _filteredCustomers;
  // List<dynamic> get customers => _filteredCustomers;

  Future<bool> addCustomer(BuildContext context, String name, String phone, String pwd) async{
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final userId = sessionProvider.userId;
    final campId = sessionProvider.campId;

    final token = Provider.of<AuthProvider>(context, listen: false).token;

    final uri = Uri.parse('https://cloudtik.trizent.net/api/register_customer');

    try{
        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
          },
          body: {
            'camp_id': campId.toString(),
            'customer_name': name,
            'contact_no': phone,
            'customer_pwd': pwd,
          }
        );

        // print('Response Status Code: ${response.statusCode}');

        if(response.statusCode == 200){
          print("CUSTOMER ADDED SUCCESSFULLY. ${response.body}");
          return true;
        }
        else {
          print('CUSTOMER ADD FAILED. ${response.body}');
          return false;
        }
    }
    catch(e){
      return false;
    }
  }//add customer

  //update customer
  Future<bool> updateCustomer(BuildContext context, String id, String name, String phone, String pwd) async{
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final userId = sessionProvider.userId;
    final campId = sessionProvider.campId;

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final uri = Uri.parse('https://cloudtik.trizent.net/api/update_customer');

    try {
      final response = await http.put(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
          },
          body: {
            'customer_id': id,
            'fullname': name,
            'phone': phone,
            'password': pwd,
          }
      );

      if(response.statusCode == 200){
        await fetchCustomers(context);
        print("CUSTOMER UPDATED SUCCESSFULLY: ${response.body}");
        return true;
      }
      else {
        print('CUSTOMER UPDATE FAILED: ${response.body}');
        return false;
      }
    }
    catch(e) {
      return false;
    }
  }//update customer

  Future<bool> fetchCustomers(BuildContext context) async{
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final userId = sessionProvider.userId;
    final campId = sessionProvider.campId;

    final token = Provider.of<AuthProvider>(context, listen: false).token;

    final uri = Uri.parse('https://cloudtik.trizent.net/api/getCustomersByCamp?camp_id=$campId');
    try{
      final response = await http.get(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
          },
      );

      // print('Response Status Code: ${response.statusCode}');

      if(response.statusCode == 200) {
        final data = json.decode(response.body);
        _customers = data;
        _filteredCustomers = data;
        notifyListeners();
        return true;
      }
      else{
        isLoading = false;
        notifyListeners();
        return false;
      }
    }
    catch(e){
      isLoading = false;
      notifyListeners();
      return false;
    }
  }//fetch customers

  //filter customers
  void filterCustomers(String query) {
    if (query.isEmpty) {
      _filteredCustomers = _customers;
    } else {
      _filteredCustomers = _customers.where((customer) {
        final name = customer['fullname']?.toLowerCase() ?? '';
        final phone = customer['phone']?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase()) || phone.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }//filter customers

  //serach customer
  Future<bool> searchCustomer(BuildContext context, String query) async{
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final userId = sessionProvider.userId;
    final campId = sessionProvider.campId;

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final uri = Uri.https(
      'cloudtik.trizent.net',
      '/api/search_customer',
      {
        'camp_id': campId.toString(),
        'search': query,
      },
    );

    try{
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // print("response $response.statusCode");

      if(response.statusCode == 200){
        final data = json.decode(response.body);
        _customers = data;
        _filteredCustomers = data;
        notifyListeners();
        return true;
      }
      else {
        return false;
      }
    }
    catch(e){
      return false;
    }
  }
}//class