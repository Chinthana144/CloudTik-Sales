import 'package:flutter/cupertino.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartLedgend extends StatelessWidget{
  final List<PieChartSectionData> data;

  const ChartLedgend({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          for(int i = 0; i < data.length; i++)
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  color: data[i].color,
                ),
                SizedBox(width: 5,),
                Text(data[i].title),
                SizedBox(width: 5,),
                Text(" : " + data[i].value.toString() + " AED")
              ]),
        ],
      ),
    );
  }

  List<dynamic> titles(){
    List<dynamic> titles = [];
    for(int i = 0; i < data.length; i++){
      titles.add(data[i].title);
    }
    return titles;
  }

  List<dynamic> colors(){
    List<dynamic> colors = [];
    for(int i = 0; i < data.length; i++){
      colors.add(data[i].color);
    }
    return colors;
  }

  List<dynamic> values() {
    List<dynamic> values = [];
    for (int i = 0; i < data.length; i++) {
      values.add(data[i].value);
    }
    return values;
  }
}//class