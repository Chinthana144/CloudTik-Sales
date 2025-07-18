import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DonutPieChart extends StatefulWidget {
  final List<PieChartSectionData> data;

  const DonutPieChart({super.key, required this.data});
  @override
  State<StatefulWidget> createState() => _DonutPieChartState();
}

class _DonutPieChartState extends State<DonutPieChart> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: showingSections(),
        centerSpaceRadius: 50,
        sectionsSpace: 2,
        pieTouchData: PieTouchData(
          touchCallback: (event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = null;
                return;
              }
              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
      ),
      swapAnimationDuration: const Duration(milliseconds: 800),
      swapAnimationCurve: Curves.easeInOut,
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.data.length, (i) {
      final isTouched = i == touchedIndex;
      final base = widget.data[i];

      return PieChartSectionData(
        value: base.value,
        title: base.title,
        color: base.color,
        radius: isTouched ? 65 : 50, // 👈 Increase radius on touch
        titleStyle: base.titleStyle,
      );
    });
  }
}//class

