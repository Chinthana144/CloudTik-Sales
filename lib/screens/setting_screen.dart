// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/reports_screen.dart';

class SettingsScreen extends StatelessWidget {
  final List<dynamic>? user;

  const SettingsScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    height: 180,
                    color: Color.fromRGBO(10, 45, 100, 1),
                    child: Column(
                      children: [
                        Text(
                            'Welcome!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          user!['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          user!['email'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                  ),

                  SizedBox(height: 10),
                  Text('Reports'),
                  SizedBox(height: 10),
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                       Text(
                           'Daily Sales Report',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                       ),
                       ElevatedButton(
                           onPressed: (){
                             Navigator.push(
                               context,
                               MaterialPageRoute(builder: (context) => ReportsScreen()),
                             );
                           },
                           child: Text('View'),
                       ),
                      ]),
                    ),
                  ),
                ]),
        ),
      ),
    );
  }
}
