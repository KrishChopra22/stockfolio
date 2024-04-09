class StockChartModel {
  StockChartModel({required this.date, required this.close});

  DateTime? date;
  num? close;

  StockChartModel.fromJson(Map<String, dynamic> json) {
    date = DateTime.parse(json['date']);
    close = json['close'];
  }

  static List<StockChartModel> toList(List<dynamic> items) {
    return items.map((item) => StockChartModel.fromJson(item)).toList();
  }
}
