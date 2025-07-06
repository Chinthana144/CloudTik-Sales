import 'package:flutter/material.dart';

class CustomerSelect extends StatelessWidget{
  final List<dynamic> customers;

  CustomerSelect({
    super.key,
    required this.customers,
  });

  @override
  Widget build(BuildContext context) {
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