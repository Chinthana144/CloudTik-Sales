// lib/screens/search_screen.dart

import 'package:cloudtik_sales/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import '../widgets/CustomTextField.dart';

class CustomerScreen extends StatefulWidget{
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('pastha'),
        ]
      )
    );
  }
}
