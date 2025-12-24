import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';

class ViewSubscription extends StatefulWidget{
  final String subscriptionId;
  final Map<String, dynamic> sub;
  ViewSubscription({
    super.key,
    required this.subscriptionId,
    required this.sub,
  });

  @override
  State<ViewSubscription> createState() => _viewSubscriptionState();
}

class _viewSubscriptionState extends State<ViewSubscription> {
  late Timer _timer;
  Duration remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemaining();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateRemaining();
    });
  }

  void _calculateRemaining() {
    final now = DateTime.now();
    // print('date: ${widget.sub['subscription']['expiry_datetime']}');
    String expiryString = widget.sub['subscription']['expiry_datetime'] == 'N/A' ? '0000-00-00 00:00:00' : widget.sub['subscription']['expiry_datetime'];
    expiryString = expiryString.replaceAll(' ', 'T');
    DateTime expiryDate = DateTime.parse(expiryString);

    remaining = expiryDate.difference(now);
    setState(() {
      if (remaining.isNegative) {
        remaining = Duration.zero;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;

    Color getStatusColor(status){
      Color colorName = Color(0xFF1976D2);
      switch(status) {
        case 1 : colorName = Color(0xFF1976D2);//active
        break;
        case 2 : colorName = Color(0xFF43A047);//running
        break;
        case 3 : colorName = Color(0xFFFFC107);//expired
        break;
        case 4 : colorName = Colors.red;//canceled
        break;
        case 5 : colorName = Color(0xFF6C757D);//transferred
        break;
      }//switch
      return colorName;
    }//get color

    String getStatus(status){
      String statusName = "ACTIVE";
      switch(status) {
        case 1: statusName = "ACTIVE";
        break;
        case 2: statusName = "RUNNING";
        break;
        case 3: statusName = "EXPIRED";
        break;
        case 4: statusName = "CANCELED";
        break;
        case 5: statusName = "TRANSFERRED";
        break;
      }
      return statusName;
    }

    return AlertDialog(
      title: Text(widget.sub['subscription']['customer_name']),
      content: Container(
        height: 420,
        child: Column(children: [
          remaining.inSeconds > 0 ?
          Text(
              '${days}d : ${hours}h : ${minutes}m : ${seconds}s',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Color(0xFF43A047),
              ),
          )
          :
          Text(
              'Not Running',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFFFFC107),
              ),
          ),
          SizedBox(height: 10),
          Text(
              widget.sub['subscription']['username'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
          ),
          SizedBox(height: 10),
          Text('Package'),
          Text(
            widget.sub['subscription']['package_name'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 5),
          Text('Purchase Date'),
          Text(
            widget.sub['subscription']['purchase_date'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 5),
          Text('Subscription Start Date Time'),
          Text(
            widget.sub['subscription']['start_datetime'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 5),
          Text('Subscription End Date Time'),
          Text(
            widget.sub['subscription']['end_datetime'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 5),
          Text('Subscription Expire Date Time'),
          Text(
            widget.sub['subscription']['expiry_datetime'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

          Text(
            getStatus(widget.sub['subscription']['status']),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: getStatusColor(widget.sub['subscription']['status']),
            ),
          ),
            

        ]),
      ),
      actions: [
        TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text('Close')
        ),
      ],
    );
  }
}