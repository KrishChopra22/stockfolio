import 'package:flutter/material.dart';
import 'package:stockfolio/features/stocks/screens/buy.dart';
import 'package:stockfolio/features/stocks/screens/sell1.dart';
import 'package:stockfolio/models/stock_search_model.dart';
import 'package:stockfolio/models/stock_transaction_model.dart';

import '../../../utils/Colors.dart';

class BuySell extends StatefulWidget {
  const BuySell({
    super.key,
    required this.allStocksList,
    required this.userStocksList,
  });

  final List<StockSearchModel> allStocksList;
  final List<StockTransactionModel> userStocksList;
  @override
  State<BuySell> createState() => _BuySellState();
}

class _BuySellState extends State<BuySell> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Text(
          'Add Trade',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        bottom: TabBar(
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50), // Creates border
            color: Colors.black,
          ),
          labelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text(
                'Buy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Tab(
              child: Text(
                'Sell',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      body:


          TabBarView(
            controller: _tabController,
            children: [
              Buy(
                allStocksList: widget.allStocksList,
              ),
              Sell(
                userStocksList: widget.userStocksList,
              ),
            ],
          ),
    );
  }
}
