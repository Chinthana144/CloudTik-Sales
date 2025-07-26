import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';

class ViewSubscription extends StatelessWidget {
  final String subscriptionId;
  final Map<String, dynamic> sub;

  const ViewSubscription({
    Key? key,
    required this.subscriptionId,
    required this.sub
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Column(
        children: [
          Text(
            '${sub['subscription']['customer_name']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      content: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(10),
        height: 320,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                '${sub['subscription']['username']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
            ),
            Text(
                'Package:  ${sub['subscription']['package_name']}',
                style: TextStyle(
                  fontSize: 18,
                ),
            ),
            Text(
                'Duration: ${sub['subscription']['package_duration']} Days',
                style: TextStyle(
                  fontSize: 18,
                ),
            ),
            Text(
                'Price: ${sub['subscription']['package_price']} AED',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
            ),
            SizedBox(height: 8,),
            //dates
            Text('Purchase Date:'),
            Text(
              '${sub['subscription']['purchase_date']}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),

            Text('Start Date:'),
            Text(
              '${sub['subscription']['start_datetime']}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),

            Text('End Date:'),
            Text(
              '${sub['subscription']['end_datetime']}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),

            Text('Expire Date:'),
            Text(
              '${sub['subscription']['expiry_datetime']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
          child: Text('OK'),
      ),
    ]
    );
  }
}
