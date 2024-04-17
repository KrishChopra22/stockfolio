import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:stockfolio/keys/api_keys.dart';
import 'package:stockfolio/models/stock_chart_model.dart';
import 'package:stockfolio/models/stock_data_model.dart';
import 'package:stockfolio/models/stock_search_model.dart';
import 'package:stockfolio/models/stock_transaction_model.dart';
import 'package:stockfolio/utils/utils.dart';

class HomeRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<StockSearchModel>> fetchStocksList() async {
    final http.Response response =
        await financialModelRequest('/api/v3/stock/list');
    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List;
      if (kDebugMode) {
        print('Stocks List fetched');
      }
      return StockSearchModel.toList(
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
      return <StockSearchModel>[];
    }
  }

  Future<StockDataModel> fetchStockData(
    String stockSymbol,
  ) async {
    final http.Response response =
        await financialModelRequest('/api/v3/quote/$stockSymbol');
    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body) as List;
      if (kDebugMode) {
        print('Stock Details fetched');
      }
      return StockDataModel.fromJson(jsonList[0]);
    } else {
      if (kDebugMode) {
        print(response.body);
      }
      return StockDataModel();
    }
  }

  Future<List<StockChartModel>> fetchStockChart(
    String stockSymbol,
  ) async {
    final now = DateTime.now();
    final toDate = DateTime(now.year, now.month, now.day).toString();
    final fromDate = DateTime(now.year - 1, now.month + 1, now.day).toString();
    final http.Response response = await apiRequest(
      'https://financialmodelingprep.com/api/v3/historical-price-full/$stockSymbol?from=$fromDate&to=$toDate&apikey=$kFinancialModelingPrepApi',
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map;
      if (kDebugMode) {
        print('Stock Chart fetched');
      }
      final jsonList = jsonData['historical'] as List;
      return StockChartModel.toList(
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
      return <StockChartModel>[];
    }
  }

  Future<StockTransactionModel> saveStockTransactionToFirebase({
    required StockTransactionModel stockTransaction,
  }) async {
    final uid = _firebaseAuth.currentUser!.uid;

    final StockTransactionModel finalStockTransaction =
        stockTransaction.copyWith(userId: uid);
    // uploading to database
    await _firebaseFirestore.collection('StockTransactions').add(
          finalStockTransaction.toJson(),
        );
    return finalStockTransaction;
  }

  Future<List<StockTransactionModel>>
      fetchStockTransactionListFromFirebase() async {
    final uid = _firebaseAuth.currentUser!.uid;
    final querySnap = await _firebaseFirestore
        .collection('StockTransactions')
        .where('userId', isEqualTo: uid)
        .get();
    print(querySnap.docs.toString());
    final docList = querySnap.docs
        .map(
          (doc) =>
              Map<String, dynamic>.from(doc.data() as Map<dynamic, dynamic>),
        )
        .toList();
    return StockTransactionModel.toList(docList);
  }
}
