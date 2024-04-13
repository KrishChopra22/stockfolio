class StockSearchModel {
  final String? symbol;
  final String? name;
  final num? price;
  final String? exchange;
  final String? exchangeShortName;

  StockSearchModel({
    this.symbol,
    this.name,
    this.price,
    this.exchange,
    this.exchangeShortName,
  });

  // from json
  factory StockSearchModel.fromJson(Map<String, dynamic> json) {
    return StockSearchModel(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      exchange: json['exchange'] ?? '',
      exchangeShortName: json['exchangeShortName'] ?? '',
    );
  }

  static List<StockSearchModel> toList(List<Map<String, dynamic>> items) {
    return items.map(StockSearchModel.fromJson).toList();
  }

// to json not required

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = <String, dynamic>{};
//   data['symbol'] = symbol;
//   data['name'] = name;
//   data['price'] = price;
//   data['exchange'] = exchange;
//   data['exchangeShortName'] = exchangeShortName;
//   return data;
// }
}
