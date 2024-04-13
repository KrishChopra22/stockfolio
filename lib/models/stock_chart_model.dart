class StockChartModel {
  final DateTime? date;
  final num? close;

  const StockChartModel({
    required this.date,
    required this.close,
  });

  factory StockChartModel.fromJson(Map<String, dynamic> json) {
    return StockChartModel(
      date: DateTime.tryParse(json['date']),
      close: json['close'],
    );
  }

  static List<StockChartModel> toList(List<Map<String, dynamic>> items) {
    return items.map(StockChartModel.fromJson).toList();
  }
}
