// lib/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/CustomTextField.dart';
import '../widgets/customer_dialog.dart';
import '../providers/session_provider.dart';
import '../providers/customer_provider.dart';

class CustomerScreen extends StatefulWidget{
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CustomerProvider>(context, listen: false).fetchCustomers(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    final customers = customerProvider.customers;

    return Scaffold(
      body: Column(
        children: [
          Text('customers'),
          Scrollbar(
            // thumbVisibility: true,
              child: Expanded(
                child: customers.isEmpty ?
                  const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    shrinkWrap: true,
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      return ListTile(
                        title: Text(customer['fullname']),
                        subtitle: Text(customer['phone']),
                        trailing: SizedBox(
                          width: 50,
                          child: IconButton(
                              onPressed: (){},
                              icon: Icon(Icons.edit),
                          )
                        ),
                      );
                    },
                  ),
                ),
              ),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => CustomerDialog(
                onSubmit: (name, phone, pwd) async {
                  await customerProvider.addCustomer(context, name, phone, pwd);
                },
              ),
            ),
            child: Icon(Icons.add),
          ),
      );
  }
}//class
