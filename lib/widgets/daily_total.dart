import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DailyTotal extends StatelessWidget{
  final List<dynamic> data;

  const DailyTotal({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(children: [
            Text('Daily count'),
            Text(
                getCount() ?? "0",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
            ),
          ],),
          Column(children: [
            Text('Daily Sale'),
            Text(
                getTotal() + ' AED' ?? "0",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
            ),
          ]),
        ],
      ),
    );
  }

  String getCount(){
    int count = data.length;
    return count.toString();
  }

  String getTotal(){
    double total = 0;
    for(int i = 0; i < data.length; i++){
      total += double.parse(data[i]['price']);
    }
    return total.toString();
  }
}//class