import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/session_provider.dart';

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

       if(response.statusCode == 200)
       {
         final data = json.decode(response.body);

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

  Future<bool> getUser(BuildContext context) async{
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final userId = sessionProvider.userId;
    final campId = sessionProvider.campId;

    final token = Provider.of<AuthProvider>(context, listen: false).token;

    final uri = Uri.https(
      'cloudtik.trizent.net',
      '/api/getOneUser',
      {
        'user_id': userId.toString(),
      },
    );

    try{
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if(response.statusCode == 200) {
        final data = json.decode(response.body);
        _user = data;
        notifyListeners();
        return true;
      }
      else{
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }
    catch(e){
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }//get user

  Future<void> logout() async{
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

}//class