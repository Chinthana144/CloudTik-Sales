// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Welcome'),
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.add),
            )
          ]
        ),
        Text('Dashboard Screen'),
        Text('User ID: ${sessionProvider.userId}'),
        Text('Camp ID: ${sessionProvider.campId}'),
      ],
    );
  }//widget
}//class
