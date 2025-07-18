// lib/screens/search_screen.dart

import 'package:flutter/material.dart';

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
                  Text('goto user profile'),
                  SizedBox(height: 20),
                  Text('goto report'),
                ]
            )
        ),
      ),
    );
  }
}
