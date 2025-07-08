import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/package_provider.dart';

class CustomerSelect extends StatelessWidget{
  final List<dynamic> customers;
  final List<dynamic>? packages;

  CustomerSelect({
    super.key,
    required this.customers,
    this.packages,
  });

  @override
  Widget build(BuildContext context) {
    final packageProvider = Provider.of<PackageProvider>(context);
    final packages = packageProvider.packages;

    return AlertDialog(
      title: Text('Select Customer'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: ListView.builder(
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
                    ),
                  ),
                  subtitle: Text(
                    customer['username'],
                  ),
                  trailing: ElevatedButton(
                      onPressed: (){
                        packageProvider.fetchPackages(context, customer['id'].toString());
                        // print('customer: $customer');
                        // print('packages: $packages');
                        // Navigator.pop(context, customer);
                        Navigator.of(context).pop({
                          'customer' : customer,
                          'packages' : packages,
                        });
                      },
                      child: Text('Select'),
                  ),
                ),
            );
          }//item builder
        )
      ),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}