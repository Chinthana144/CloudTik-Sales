import 'package:flutter/material.dart';

class CustomerHistory extends StatelessWidget{
  final List<dynamic> subscriptions;

  CustomerHistory({
    super.key,
    required this.subscriptions,
  });

  Color getStatusColor(int status) {
    switch (status) {
      case 1:
        return const Color(0xFF1976D2); // Active - Blue
      case 2:
        return const Color(0xFF43A047); // Running - Green
      case 3:
        return const Color(0xFFFFC107); // Expired - Yellow
      case 5:
        return const Color(0xFF6C757D); // Transferred - Gray (Bootstrap Secondary)
      case 4:
        return const Color(0xFFDC3545); // Canceled - Red (Bootstrap Danger)
      default:
        return Colors.red; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Customer History'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: ListView.builder(
          itemCount: subscriptions.length,
            itemBuilder: (context, index){
              final item = subscriptions[index];
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(6.0),
                margin: const EdgeInsets.symmetric(vertical: 3.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5), // background color (light gray, you can change this)
                  border: Border.all(
                    color: getStatusColor(item['status']), // border color (indigo tone)
                    width: 2, // border thickness
                  ),
                  borderRadius: BorderRadius.circular(12), // rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // optional subtle shadow
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      Text(item['name'].toString()),
                      Text('Start: ' + item['subscriptionStartTime'].toString() == '' ? 'N/A' : item['subscriptionStartTime'].toString()),
                      Text('Expire: ' + item['subscriptionEndTime'].toString() == '' ? 'N/A' : item['subscriptionEndTime'].toString()),
                    ]),
                    Column(children: [
                      Text(
                          item['purchaseDate'].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: getStatusColor(item['status']),
                              fontSize: 16,
                          ),
                      ),
                      Text(
                        item['price'] + 'AED',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getStatusColor(item['status']),
                            fontSize: 20,
                        ),
                      )
                    ]),
                  ],
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
          child: Text('Close'),
        ),
      ],
    );
  }
}//class