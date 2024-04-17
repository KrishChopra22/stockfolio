import 'package:flutter/material.dart';
import 'package:stockfolio/features/stocks/screens/sell1.dart';

import 'buy.dart';

class BuySell extends StatefulWidget {
  const BuySell({Key? key}) : super(key: key);
  @override
  State<BuySell> createState() => _BuySellState();
}

class _BuySellState extends State<BuySell> with SingleTickerProviderStateMixin {
  Widget appBarTitle = Center(child: Text('New Trade'));
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
        title: appBarTitle,
        bottom: TabBar(
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50), // Creates border
              color: Colors.black),
          labelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text('Buy'),
            ),
            Tab(
              child: Text('Sell'),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Buy(),
          Sell()
        ],
      ),
    );
  }
}
