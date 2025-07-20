import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BarChart7Days extends StatelessWidget{
  final Map<String, dynamic>? data;

  const BarChart7Days({
    super.key,
    required this.data
  });


  @override
  Widget build(BuildContext context) {
    List<dynamic> values = data!['total_prices'];
    List<double> yValues = values.map((value) => double.parse(value)).toList();
    final maxValue = yValues.reduce((a, b) => a > b ? a : b);
    double maxY = maxValue + (maxValue * 0.1);

    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        barGroups: barGroups,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(data!['dates'][value.toInt()]);
              },
            ),
          ),
        ),
      ),
    );
  }//build


  List<BarChartGroupData> get barGroups {
    List<BarChartGroupData> barGroups = [];
    for (int i = 0; i < data!['dates'].length; i++) {
      final value = double.parse(data!['total_prices'][i]);
      barGroups.add(
          BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: value,
                  color: Colors.blue,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                )
              ],
          ),
      );
    } //for
    return barGroups;
  }//barGroups
}//class