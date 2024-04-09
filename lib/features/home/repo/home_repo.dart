import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stockfolio/keys/api_keys.dart';
import 'package:stockfolio/models/stock_chart_model.dart';
import 'package:stockfolio/models/stock_data_model.dart';
import 'package:stockfolio/models/stock_search_model.dart';
import 'package:stockfolio/utils/utils.dart';

class HomeRepository {
  Future<List<StockSearchModel>> fetchStocksList() async {
    final http.Response response =
        await financialModelRequest('/api/v3/stock/list');
    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body);
      print("Stocks List fetched");
      return StockSearchModel.toList(jsonList);
    } else {
      print(response.body);
      return <StockSearchModel>[];
    }
  }

  Future<StockDataModel> fetchStockData(
    String stockSymbol,
  ) async {
    final http.Response response =
        await financialModelRequest('/api/v3/quote/$stockSymbol');
    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body);
      print("Stock Details fetched");
      return StockDataModel.fromJson(jsonList[0]);
    } else {
      print(response.body);
      return StockDataModel();
    }
  }

  Future<List<StockChartModel>> fetchStockChart(
    String stockSymbol,
  ) async {
    final DateTime now = DateTime.now();
    String toDate = DateTime(now.year, now.month, now.day).toString();
    String fromDate = DateTime(now.year - 1, now.month + 1, now.day).toString();
    final http.Response response = await apiRequest(
      'https://financialmodelingprep.com/api/v3/historical-price-full/$stockSymbol?from=$fromDate&to=$toDate&apikey=$kFinancialModelingPrepApi',
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print("Stock Chart fetched");
      return StockChartModel.toList(jsonData['historical']);
    } else {
      print(response.body);
      return <StockChartModel>[];
    }
  }
}
