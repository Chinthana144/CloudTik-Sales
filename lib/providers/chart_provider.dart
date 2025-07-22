import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import '../providers/session_provider.dart';
import '../providers/auth_provider.dart';

class ChartProvider with ChangeNotifier {
  List<BarChartData> _chartData = [];
  List<dynamic> newData = [];
  Map<String, dynamic>? _myData;
  List<PieChartSectionData> _sections = [];

  List<BarChartData> get chartData => _chartData;
  List<dynamic> get chartData1 => newData;
  Map<String, dynamic>? get myData => _myData;
  List<PieChartSectionData> get sections => _sections;

  Future<void> fetchBarChartData(BuildContext context) async {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final userId = sessionProvider.userId;
    final campId = sessionProvider.campId;

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final uri = Uri.https(
      'cloudtik.trizent.net',
      '/api/getBarChartData',
      {
        'camp_id': campId.toString(),
        'user_id': userId.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('chart provider = ${data}');

      _myData = data;

      notifyListeners();
    } else {
      throw Exception('Failed to load chart data');
    }
  }

  //fetch chart data
  Future<void> fetchChartData(BuildContext context) async{
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final userId = sessionProvider.userId;
    final campId = sessionProvider.campId;

    final today = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(today);

    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final uri = Uri.https(
      'cloudtik.trizent.net',
      '/api/getDonutChartData',
      {
        'camp_id': campId.toString(),
        'user_id': userId.toString(),
        'search_date': formattedDate.toString(),
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    // print('fetch cart data = ${response.statusCode}');

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);

      List<String> values = List<String>.from(data['values']);
      List<String> colors = List<String>.from(data['colors']);
      List<String> titles = List<String>.from(data['titles']);

      // print('titles = $titles');

      _sections = List.generate(values.length, (index) {
        return PieChartSectionData(
          value: double.parse(values[index]),
          title: '${titles[index]}',
          color: _hexToColor(colors[index]),
          radius: 50,
          titleStyle: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
          // badgeWidget: Text(titles[index]),
          badgePositionPercentageOffset: 1.2,
        );
      });
      notifyListeners();
    }
    else{
      print('data fetch failed...');
      throw Exception('Failed to load chart data');
    }
  }//fetch chart data

  Color _hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

}//class
