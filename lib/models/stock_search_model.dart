class StockSearchModel {
  StockSearchModel({
    this.symbol,
    this.name,
    this.price,
    this.exchange,
    this.exchangeShortName,
  });
  String? symbol;
  String? name;
  num? price;
  String? exchange;
  String? exchangeShortName;

  // from json
  StockSearchModel.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'] ?? '';
    name = json['name'] ?? '';
    price = json['price'] ?? 0;
    exchange = json['exchange'] ?? '';
    exchangeShortName = json['exchangeShortName'] ?? '';
  }

  static List<StockSearchModel> toList(List<dynamic> items) {
    return items.map((item) => StockSearchModel.fromJson(item)).toList();
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
