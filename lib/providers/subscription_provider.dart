import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/session_provider.dart';
import '../providers/auth_provider.dart';

class SubscriptionProvider extends ChangeNotifier{
  bool isLoading = false;

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
}//class