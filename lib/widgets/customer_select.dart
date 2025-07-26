import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/package_provider.dart';

class CustomerSelect extends StatelessWidget{
  final List<dynamic> customers;
  final List<Map<String, dynamic>>? packages;

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
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final item = customers[index];
            return ListTile(
              title: Text(item['customer']['fullname']),
              subtitle: Text(item['customer']['username']),
              trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: (){
                    Navigator.of(context).pop({
                      'customer' : item['customer'],
                      'packages' : item['packages'],
                    });
                    print('selected packages: ${item['packages']}');
                  },
                  child: Text('Select'),
              ),
            );
          }
        ),
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