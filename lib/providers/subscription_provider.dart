import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/session_provider.dart';
import '../providers/auth_provider.dart';

class SubscriptionProvider extends ChangeNotifier{
  bool isLoading = false;
  List<dynamic> _subscriptions = [];

  List<dynamic> get subscriptions => _subscriptions;

  Future<bool> addSubscription(BuildContext context, String customerId, String packageId) async{
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final userId = sessionProvider.userId;
    final campId = sessionProvider.campId;

    final token = Provider.of<AuthProvider>(context, listen: false).token;

    final uri = Uri.parse('https://cloudtik.trizent.net/api/addSubscriptionFromAPI');

    try{
      final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
          },
          body: {
              "user_id" : userId.toString(),
              "camp_id" : campId.toString(),
              "customer_id" : customerId,
              "package_id" : packageId,
          }
      );
      // print('code ${response.statusCode}');

      if(response.statusCode == 200){
        print('subscription submitted successfully...');
        return true;
      }
      else{
        print('subscription submission failed...');
        return false;
      }
    }
    catch(e){
      print('subscription submission failed...catch');
      return false;
    }
  }//add subscription

  Future<bool> fetchSubscriptionsByUserDate(BuildContext context) async{
    clearSubscriptions();
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final userId = sessionProvider.userId;
    final campId = sessionProvider.campId;

    final today = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(today);

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final uri = Uri.https(
      'cloudtik.trizent.net',
      '/api/getSubscriptionByUserDate',
      {
        'camp_id': campId.toString(),
        'user_id': userId.toString(),
        'search_date': formattedDate.toString(),
      },
    );

    try{
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("fetch subs code =  $response.statusCode");

      if(response.statusCode == 200) {
        final data = json.decode(response.body);
        _subscriptions = data;
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
  }//fetch subs

  //search subscription by user
  Future<bool> searchSubscriptionByUser(BuildContext context, String searchText) async{
    clearSubscriptions();

    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final userId = sessionProvider.userId;
    final campId = sessionProvider.campId;

    final today = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(today);

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final uri = Uri.https(
      'cloudtik.trizent.net',
      '/api/searchSubscriptionsByUser',
      {
        'camp_id': campId.toString(),
        'user_id': userId.toString(),
        'search': searchText,
      },
    );

    try{
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print("search subs code =  $response.statusCode");

      if(response.statusCode == 200) {
        final data = json.decode(response.body);
        _subscriptions = data;
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

  void clearSubscriptions() {
    _subscriptions = [];
    notifyListeners();
  }
}//class