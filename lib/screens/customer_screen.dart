// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/customer_provider.dart';
import '../widgets/customer_dialog.dart';
import '../widgets/qrcode_dialog.dart';

class CustomerScreen extends StatefulWidget{
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen>{
  final _formKey = GlobalKey<FormState>();
  final List<dynamic> customers = [];

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CustomerProvider>(context, listen: false).fetchCustomers(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    final customers = customerProvider.customers;

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              // onChanged: (value) {
              //
              //   // customerProvider.fetchCustomers(context);
              // },
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    customerProvider.searchCustomer(context, _searchController.text);
                    _searchController.clear();
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Scrollbar(
              child: customers.isEmpty ?
              const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  final customer = customers[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          customer['fullname'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          customer['username'],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        trailing: SizedBox(
                            width: 50,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: (){
                                    showDialog(
                                      context: context,
                                      builder: (context) => CustomerDialog(
                                        title: 'Edit Customer',
                                        name: customer['fullname'],
                                        phone: customer['phone'],
                                        pwd: customer['password'],
                                        onSubmit: (name, phone, pwd) async {
                                          final success = await customerProvider.updateCustomer(context, customer['id'].toString(), name, phone, pwd);
                                          if(success){
                                            Navigator.pop(context);
                                            customerProvider.fetchCustomers(context);
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                )
                              ]),

                        ),
                      ),
                    );
                  }
                ),
              ),
            ),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => CustomerDialog(
                onSubmit: (name, phone, pwd) async {
                  final success = await customerProvider.addCustomer(context, name, phone, pwd);
                  if(success){
                    Navigator.pop(context);
                    customerProvider.fetchCustomers(context);
                  }
                },
              ),
            ),
            child: Icon(Icons.add),
          ),
      );
  }
}//class
