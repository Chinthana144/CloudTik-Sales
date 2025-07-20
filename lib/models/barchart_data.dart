class BarChartData {
  final String day;
  final double value;

  BarChartData({required this.day, required this.value});

  factory BarChartData.fromJson(Map<String, dynamic> json) {
    return BarChartData(
      day: json['day'],
      value: (json['value'] as num).toDouble(),
    );
  }
}
