class StockNewsModel {
  final DateTime? date;
  final String? title;
  final String? tickers;
  final String? imageUrl;
  final String? newsUrl;
  final String? authorName;

  const StockNewsModel({
    required this.date,
    required this.title,
    required this.tickers,
    required this.imageUrl,
    required this.newsUrl,
    required this.authorName,
  });

  factory StockNewsModel.fromJson(Map<String, dynamic> json) {
    return StockNewsModel(
      date: DateTime.tryParse(json['date']),
      title: json['title'] ?? '',
      tickers: json['tickers'] ?? '',
      imageUrl: json['image'] ?? '',
      newsUrl: json['link'] ?? '',
      authorName: json['author'] ?? '',
    );
  }

  static List<StockNewsModel> toList(List<Map<String, dynamic>> items) {
    return items.map(StockNewsModel.fromJson).toList();
  }
}
