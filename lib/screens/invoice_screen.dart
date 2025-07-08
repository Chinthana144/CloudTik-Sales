// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/customer_provider.dart';
import '../providers/package_provider.dart';
import '../widgets/customer_select.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<dynamic> customers = [];
  Map<String, dynamic>? packages;

  bool _dialogShown = false;
  Map<String, dynamic>? _selectedCustomer;
  List<Map<String, dynamic>> _selectedPackage = [];

  final _searchController = TextEditingController();
  final _packageController = TextEditingController();

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
        ).then((result) {
          if (result != null) {
            setState(() {
              _selectedCustomer = result['customer'];
              _selectedPackage = List<Map<String, dynamic>>.from(result['packages']);
              // _selectedPackage = result['packages'];
            });
          }
          customers.clear();
          customerProvider.clearCustomers();
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
                        print('search customers');
                        // customers.clear();
                        customerProvider.clearCustomers();
                        customerProvider.searchCustomer(context, _searchController.text);
                        print('customers - $customers');
                      },
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                // customers.length > 1 ? Text('open panel') : Text('select customer')
              ],),
            ),

            if(_selectedCustomer != null)
              Card(
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text(
                          '${_selectedCustomer!['fullname']}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                      Text('${_selectedCustomer!['phone']}'),
                    ],),
                ),
              ),

            if(_selectedPackage.isNotEmpty)
              Card(
                child : DropdownButton(
                    hint: Text('Select package'),
                    isExpanded: true,
                    items: _selectedPackage.map((package) {
                      return DropdownMenuItem(
                        value: _packageController.text.isEmpty ? 'Select package' : _packageController.text,
                        child: Text(package['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _packageController.text = value!;
                      });
                    },
                ),
              ),

            Text('${_selectedPackage.length}'),

          ],
        ),
      ),
    );
  }
}//class