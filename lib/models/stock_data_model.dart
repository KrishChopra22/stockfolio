class StockDataModel {
  StockDataModel({
    this.symbol,
    this.name,
    this.price,
    this.changesPercentage,
    this.change,
    this.dayLow,
    this.dayHigh,
    this.yearHigh,
    this.yearLow,
    this.marketCap,
    this.priceAvg50,
    this.priceAvg200,
    this.exchange,
    this.volume,
    this.avgVolume,
    this.open,
    this.previousClose,
    this.eps,
    this.pe,
    this.earningsAnnouncement,
    this.sharesOutstanding,
    this.timestamp,
  });
  String? symbol;
  String? name;
  num? price;
  num? changesPercentage;
  num? change;
  num? dayLow;
  num? dayHigh;
  num? yearHigh;
  num? yearLow;
  num? marketCap;
  num? priceAvg50;
  num? priceAvg200;
  String? exchange;
  String? imageUrl;
  int? volume;
  int? avgVolume;
  num? open;
  num? previousClose;
  num? eps;
  num? pe;
  String? earningsAnnouncement;
  num? sharesOutstanding;
  int? timestamp;

  // from json
  StockDataModel.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'] ?? '';
    name = json['name'] ?? '';
    price = json['price'] ?? 0.0;
    changesPercentage = json['changesPercentage'] ?? 0.0;
    change = json['change'] ?? 0.0;
    dayLow = json['dayLow'] ?? 0.0;
    dayHigh = json['dayHigh'] ?? 0.0;
    yearHigh = json['yearHigh'] ?? 0.0;
    yearLow = json['yearLow'] ?? 0.0;
    marketCap = json['marketCap'] ?? 0.0;
    priceAvg50 = json['priceAvg50'] ?? 0.0;
    priceAvg200 = json['priceAvg200'] ?? 0.0;
    exchange = json['exchange'] ?? '';
    imageUrl = 'https://financialmodelingprep.com/image-stock/$symbol.png';
    volume = json['volume'] ?? 0;
    avgVolume = json['avgVolume'] ?? 0;
    open = json['open'] ?? 0.0;
    previousClose = json['previousClose'] ?? 0.0;
    eps = json['eps'] ?? 0.0;
    pe = json['pe'] ?? 0.0;
    earningsAnnouncement = json['earningsAnnouncement'] ?? '';
    sharesOutstanding = json['sharesOutstanding'] ?? 0.0;
    timestamp = json['timestamp'] ?? 0;
  }

  // to json not required

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['symbol'] = symbol;
  //   data['name'] = name;
  //   data['price'] = price;
  //   data['changesPercentage'] = changesPercentage;
  //   data['change'] = change;
  //   data['dayLow'] = dayLow;
  //   data['dayHigh'] = dayHigh;
  //   data['yearHigh'] = yearHigh;
  //   data['yearLow'] = yearLow;
  //   data['marketCap'] = marketCap;
  //   data['priceAvg50'] = priceAvg50;
  //   data['priceAvg200'] = priceAvg200;
  //   data['exchange'] = exchange;
  //   data['volume'] = volume;
  //   data['avgVolume'] = avgVolume;
  //   data['open'] = open;
  //   data['previousClose'] = previousClose;
  //   data['eps'] = eps;
  //   data['pe'] = pe;
  //   data['earningsAnnouncement'] = earningsAnnouncement;
  //   data['sharesOutstanding'] = sharesOutstanding;
  //   data['timestamp'] = timestamp;
  //   return data;
  // }
}
