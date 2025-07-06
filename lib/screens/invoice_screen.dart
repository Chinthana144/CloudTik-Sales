// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/customer_provider.dart';
import '../widgets/customer_select.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<dynamic> customers = [];
  bool _dialogShown = false;

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    final customers = customerProvider.customers;

    if (customers.isNotEmpty && !_dialogShown) {
      _dialogShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => CustomerSelect(customers: customers),
        ).then((_) {
          _dialogShown = false;
        });
      });
    }

    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Invoice Screen'),
            Form(
              key: _formKey,
              child: Column(children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        customerProvider.clearCustomers();
                        customerProvider.searchCustomer(context, _searchController.text);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                // customers.length > 1 ? Text('open panel') : Text('select customer')
              ],),
            ),
          ],
        ),
      ),

    );
  }
}//class