class StockTransactionModel {
  StockTransactionModel({
    required this.stockSymbol,
    required this.userId,
    required this.price,
    required this.quantity,
    required this.exchangeName,
    required this.isBought,
    required this.transactionDate,
  });
  final String? stockSymbol;
  final String? userId;
  double? price;
  int? quantity;
  final String? exchangeName;
  final bool? isBought;
  DateTime? transactionDate;

  // from json
  factory StockTransactionModel.fromJson(Map<String, dynamic> json) {
    return StockTransactionModel(
      stockSymbol: json['stockSymbol'] ?? '',
      userId: json['userId'] ?? '',
      price: json['price'] ?? 0.0,
      quantity: json['quantity'] ?? 0,
      exchangeName: json['exchangeName'] ?? '',
      isBought: json['isBought'] ?? true,
      transactionDate: DateTime.parse(json['transactionDate']),
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stockSymbol'] = stockSymbol;
    data['userId'] = userId;
    data['price'] = price;
    data['quantity'] = quantity;
    data['exchangeName'] = exchangeName;
    data['isBought'] = isBought;
    data['transactionDate'] = transactionDate.toString();
    return data;
  }

  static List<StockTransactionModel> toList(List<dynamic> items) {
    return items.map((item) => StockTransactionModel.fromJson(item)).toList();
  }

  StockTransactionModel copyWith({
    String? stockSymbol,
    String? userId,
    double? price,
    int? quantity,
    String? exchangeName,
    bool? isBought,
    DateTime? transactionDate,
  }) {
    return StockTransactionModel(
      stockSymbol: stockSymbol ?? this.stockSymbol,
      userId: userId ?? this.userId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      exchangeName: exchangeName ?? this.exchangeName,
      isBought: isBought ?? this.isBought,
      transactionDate: transactionDate ?? this.transactionDate,
    );
  }
}
