// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import '../screens/reports_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                            'User profile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                        ),
                      ]),
                  ),
                  SizedBox(height: 20),
                  Text('goto report'),
                  ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ReportsScreen()),
                        );
                      },
                      child: Text('goto reports'),
                  ),
                ]),
        ),
      ),
    );
  }
}
