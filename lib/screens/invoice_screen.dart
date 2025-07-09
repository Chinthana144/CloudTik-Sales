// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/customer_provider.dart';
import '../providers/package_provider.dart';
import '../providers/subscription_provider.dart';
import '../widgets/customer_select.dart';
import '../widgets/qrcode_dialog.dart';

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
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
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
          _searchController.clear();
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
                      Text(
                          '${_selectedCustomer!['phone']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                      ),
                    ],),
                ),
              ),

            if(_selectedPackage.isNotEmpty)
              Card(
                child : Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _selectedPackage.length,
                        itemBuilder: (context, index) {
                          final package = _selectedPackage[index];
                          return Card(
                            child: ListTile(
                              title: Text(
                                '${package['name']} : ${package['price']} AED',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${package['duration']} Days'
                              ),
                              trailing: ElevatedButton(
                                onPressed: () async{
                                    // print('submit subscription ${package['id']}');
                                    // print('submit customer ${_selectedCustomer!['id']}');

                                    // final success = await subscriptionProvider.addSubscription(context, _selectedCustomer!['id'].toString(), package['id'].toString());
                                    final success = await subscriptionProvider.addSubscription(context, _selectedCustomer!['id'].toString(), package['id'].toString());

                                    if(success){
                                      print('package submitted...');
                                      final qrData = 'https://cloudtik.trizent.net/userlogin';
                                      showDialog(
                                        context: context,
                                        builder: (context) => QrcodeDialog(qrData: qrData),
                                      ).then(
                                        (value) => Navigator.of(context).pop(),
                                      );

                                      // Navigator.pop(context);
                                      _selectedCustomer = null;
                                      _selectedPackage.clear();
                                      _searchController.clear();
                                      // _dialogShown = false;
                                      customers.clear();
                                    }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.blue[800]),
                                  foregroundColor: MaterialStateProperty.all(Colors.white),
                                ),
                                child: Text('Submit'),
                              )
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ),

            Text('${_selectedPackage.length}'),

          ],
        ),
      ),
    );
  }
}//class