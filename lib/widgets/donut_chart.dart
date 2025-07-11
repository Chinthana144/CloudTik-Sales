import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DonutPieChart extends StatelessWidget {
  final List<PieChartSectionData> data;

  const DonutPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: data,
        centerSpaceRadius: 60, // Makes it a donut
        sectionsSpace: 2,
        // pieTouchData: PieTouchData(
        //   touchCallback: (FlTouchEvent event, pieTouchResponse) {
        //     if (!event.isInterestedForInteractions ||
        //         pieTouchResponse == null ||
        //         pieTouchResponse.touchedSection == null) {
        //       return;
        //     }
        //
        //   }
        // )
        // swapAnimationDuration: const Duration(milliseconds: 800),
        // swapAnimationCurve: Curves.easeInOut,// Space between segments
      ),
    );
  }
}
