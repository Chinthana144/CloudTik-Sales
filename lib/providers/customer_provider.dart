import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/session_provider.dart';
import '../providers/auth_provider.dart';

class CustomerProvider with ChangeNotifier {
  bool isLoading = false;
  List<dynamic> _customers = [];

  List<dynamic> get customers => _customers;

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
          print("CORRECT RESPONSE ${response.body}");
          return true;
        }
        else {
          print('Error Response: ${response.body}');
          return false;
        }
    }
    catch(e){
      return false;
    }
  }//add customer

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

  }
}//class