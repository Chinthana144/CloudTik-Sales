import 'package:cloudtik_sales/providers/subscription_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/chart_provider.dart';
import '../widgets/bar_chart.dart';
import '../widgets/donut_chart.dart';
import '../widgets/chart_ledgend.dart';
import '../widgets/daily_total.dart';

class DashboardScreen extends StatefulWidget{
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}//class

class _DashboardScreenState extends State<DashboardScreen>{
  bool _isLoading = false;
  Map<String, dynamic>? myData;
  List<PieChartSectionData> sections = [];
  List<dynamic> newData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      Provider.of<ChartProvider>(context, listen: false).fetchBarChartData(context);
      Provider.of<ChartProvider>(context, listen: false).fetchChartData(context);
      Provider.of<SubscriptionProvider>(context, listen: false).fetchSubscriptionsByUserDate(context, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chartProvider = Provider.of<ChartProvider>(context);
    final subsProvider = Provider.of<SubscriptionProvider>(context);
    myData = chartProvider.myData;
    sections = chartProvider.sections;
    newData = subsProvider.subscriptions;

    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: DailyTotal(data: newData),
              ),
              SizedBox(height: 10,),
              Card(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: sections.isEmpty ? CircularProgressIndicator() : DonutPieChart(data: sections),
                      ),
                      SizedBox(
                        height: 100,
                        child: sections.isEmpty ? CircularProgressIndicator() : ChartLedgend(data: sections),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: myData == null ? Text('no data') : BarChart7Days(data: myData),
                ),
              ),
            ],
          ),
        ),
    );
  }
}