import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget{
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}//class

class _ReportsScreenState extends State<ReportsScreen>{
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: Center(
        child: Text('Reports Screen'),
      ),
    );
  }
}//class