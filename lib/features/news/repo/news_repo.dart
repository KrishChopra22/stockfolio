import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:stockfolio/keys/api_keys.dart';
import 'package:stockfolio/models/stock_news_model.dart';
import 'package:stockfolio/utils/utils.dart';

class NewsRepository {
  Future<List<StockNewsModel>> fetchStockNews() async {
    final http.Response response = await apiRequest(
      'https://financialmodelingprep.com/api/v3/fmp/articles?page=0&size=10/&apikey=$kFinancialModelingPrepApi',
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;
      if (kDebugMode) {
        print('Stock News fetched');
      }
      final jsonList = jsonData['content'] as List;
      return StockNewsModel.toList(
        jsonList
            .map(
              (json) =>
                  Map<String, dynamic>.from(json as Map<dynamic, dynamic>),
            )
            .toList(),
      );
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      return <StockNewsModel>[];
    }
  }
}
