import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier{
  bool _isLoading = false;
  String? _token;
  Map<String, dynamic>? _user;
  List<dynamic> _userCamps = [];

  bool get isLoading => _isLoading;
  String? get token => _token;
  Map<String, dynamic>? get user => _user;
  List<dynamic> get userCamps => _userCamps;

  Future<bool> login(String email, String password) async{
    _isLoading = true;
    notifyListeners();

    final uri = Uri.parse('https://cloudtik.trizent.net/api/login');
    try{
     final response = await http.post(uri, body: {
         'email': email,
         'password': password,
       },
     );

     final data = json.decode(response.body);

     if(data['token'] != null)
       {
         _token = data['token'];
         _user = data['user'];
         _userCamps = data['user_camps'];

         final prefs = await SharedPreferences.getInstance();
         await prefs.setString('token', _token!);

         _isLoading = false;
         notifyListeners();

         return true;
       }
     else{
       _isLoading = false;
       notifyListeners();
       return false;
     }
    }//try
    catch(e){
      _isLoading = false;
      notifyListeners();
      return false;
     }
  }

  Future<void> logout() async{
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

}//class