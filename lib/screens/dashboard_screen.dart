// lib/screens/search_screen.dart

import 'package:cloudtik_sales/providers/subscription_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';
import '../widgets/donut_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SubscriptionProvider>(context, listen: false).fetchChartData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final sections = subscriptionProvider.sections;

    // List<PieChartSectionData> getPieData() {
    //   return List.generate(
    //       4,
    //           (i){
    //         double value = (i+1)*10;
    //         final radius = 70.0;
    //         final fontSize = 18.0;
    //         return PieChartSectionData(
    //           color: Colors.primaries[i],
    //           value: value,
    //           title: '$value',
    //           radius: radius,
    //           titleStyle: TextStyle(
    //             fontSize: fontSize,
    //             fontWeight: FontWeight.bold,
    //             color: Colors.white,
    //           ),
    //           badgeWidget: Text('$value'),
    //           badgePositionPercentageOffset: 1.2,
    //         );
    //       }
    //   );
    // }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text(
                        'Dashboard',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                    ),
                    IconButton(
                        onPressed: (){
                          Provider.of<SubscriptionProvider>(context, listen: false).fetchChartData(context);
                        },
                        icon: Icon(Icons.refresh),
                    ),
                ]),
                SizedBox(
                  height: 300,
                  child: sections.isEmpty ? const Center(
                      child: CircularProgressIndicator()
                  )
                  : DonutPieChart(data : sections),
                ),
                SizedBox(height: 20,),
                Text('Daily Sale'),
                SizedBox(height: 20,),
                Text('Token Count'),
              ]),
        ),
      ),
    );
  }
}
