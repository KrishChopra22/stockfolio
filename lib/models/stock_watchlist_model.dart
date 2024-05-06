class StockWatchListModel {
  StockWatchListModel({
    required this.stockSymbol,
    required this.stockName,
    required this.userId,
    required this.price,
    required this.exchangeName,
    required this.dateAdded,
  });
  final String? stockSymbol;
  final String? stockName;
  final String? userId;
  final double? price;
  final String? exchangeName;
  final DateTime? dateAdded;

  // from json
  factory StockWatchListModel.fromJson(Map<String, dynamic> json) {
    return StockWatchListModel(
      stockSymbol: json['stockSymbol'] ?? '',
      stockName: json['stockName'] ?? '',
      userId: json['userId'] ?? '',
      price: json['price'] ?? 0.0,
      exchangeName: json['exchangeName'] ?? '',
      dateAdded: DateTime.parse(json['dateAdded']),
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stockSymbol'] = stockSymbol;
    data['stockName'] = stockName;
    data['userId'] = userId;
    data['price'] = price;
    data['exchangeName'] = exchangeName;
    data['dateAdded'] = dateAdded.toString();
    return data;
  }

  static List<StockWatchListModel> toList(List<dynamic> items) {
    return items.map((item) => StockWatchListModel.fromJson(item)).toList();
  }

  StockWatchListModel copyWith({
    String? stockSymbol,
    String? userId,
    double? price,
    String? stockName,
    String? exchangeName,
    DateTime? dateAdded,
  }) {
    return StockWatchListModel(
      stockSymbol: stockSymbol ?? this.stockSymbol,
      userId: userId ?? this.userId,
      price: price ?? this.price,
      stockName: stockName ?? this.stockName,
      exchangeName: exchangeName ?? this.exchangeName,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}
