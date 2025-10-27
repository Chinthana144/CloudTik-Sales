import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/session_provider.dart';
import '../providers/auth_provider.dart';

class PackageProvider extends ChangeNotifier{
  bool isLoading = false;
  List<dynamic> _packages = [];

  List<dynamic> get packages => _packages;

  Future<bool> fetchPackages(BuildContext context, String customerId) async{
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final userId = sessionProvider.userId;
    final campId = sessionProvider.campId;

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final uri = Uri.https(
      'cloudtik.trizent.net',
      '/api/getCustomerPackages',
      {
        'camp_id': campId.toString(),
        'customer_id': customerId,
      },
    );

    try{
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('PACKAGE STATUS CODE: ${response.statusCode}');

      if(response.statusCode == 200){
        final data = json.decode(response.body);
        _packages = data;

        notifyListeners();
        return true;
      }
      else{
        return false;
      }
    }
    catch(e){
      return false;
    }
  }//fetch packages

  //fetch customers with packages
  Future<List<dynamic>> fetchCustomersWithPackages(BuildContext context, String query) async {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final userId = sessionProvider.userId;
    final campId = sessionProvider.campId;
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    final uri = Uri.https(
      'cloudtik.trizent.net',
      '/api/customersWithPackages',
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
      print('Response Status Code: ${response}');

      if(response.statusCode == 200){
        final data = json.decode(response.body);
        return data;
      }
      else{
        print('no result');
        return [];
      }
    }
    catch(e){
      print('catch error');
      return [];
    }

  }//fetch customers with packages

  void clearPackages() {
    _packages = [];
    notifyListeners();
  }
}//class