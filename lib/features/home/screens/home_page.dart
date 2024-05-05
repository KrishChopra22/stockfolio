import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stockfolio/features/dashboard/repo/dashboard_repo.dart';
import 'package:stockfolio/features/home/screens/widgets/current_holding_stocks.dart';
import 'package:stockfolio/features/home/screens/widgets/past_holding_stocks.dart';
import 'package:stockfolio/models/stock_transaction_model.dart';
import 'package:stockfolio/utils/Colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    getUserStocksList();
  }

  DashboardRepository dashboardRepository = DashboardRepository();
  List<StockTransactionModel> userHoldings = <StockTransactionModel>[];
  List<StockTransactionModel> pastUserHoldings = <StockTransactionModel>[];
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _stockStream;

  Future<void> getUserStocksList() async {
    _stockStream = dashboardRepository.getStocksStream();
    setState(() {});
  }

  int currentHolding = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.all(8),
              //   child: GestureDetector(
              //     onTap: () async {
              //       fetched
              //           ? await showSearch(
              //               context: context,
              //               delegate:
              //                   CustomSearchDelegate(stocksList: fullStocksList),
              //             )
              //           : showSnackBar(
              //               context,
              //               "Please wait, we're fetching stocks",
              //             );
              //     },
              //     child: Container(
              //       height: 50,
              //       width: MediaQuery.of(context).size.width * 0.9,
              //       decoration: BoxDecoration(
              //         // boxShadow: <BoxShadow>[
              //         //   BoxShadow(
              //         //     color: Colors.grey,
              //         //     offset: Offset.fromDirection(1, 2),
              //         //     spreadRadius: 0.4,
              //         //     blurRadius: 1,
              //         //   ),
              //         // ],
              //         color: Colors.grey.shade100,
              //         borderRadius: BorderRadius.circular(24),
              //         border: Border.all(color: Colors.black87),
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.all(8),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: <Widget>[
              //             Text(
              //               fetched
              //                   ? '  Search Stocks/ETFs...'
              //                   : '  Initialising...',
              //               style: const TextStyle(
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.w500,
              //               ),
              //             ),
              //             const Icon(Icons.search_rounded),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
              Card(
                color: AppColors.lightBlue,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Invested ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Current Amount ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '100000',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '100000',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: AppColors.black,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'P/L: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            '+100',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '10%',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // CustomButton(
              //   text: 'Play Game',
              //   onPressed: () async {
              //     await Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (BuildContext context) => const GameScreen(),
              //       ),
              //     );
              //   },
              // ),
              DefaultTabController(
                length: 2,
                child: Padding(
                  padding: const EdgeInsets.all(13),
                  child: TabBar(
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50), // Creates border
                      color: Colors.black,
                    ),
                    labelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                    // controller: _tabController,
                    tabs: const [
                      Tab(
                        child: Text('Current Holdings'),
                      ),
                      Tab(
                        child: Text('Past Holdings'),
                      ),
                    ],
                    onTap: (value) {
                      currentHolding = value;
                      setState(() {});
                    }, // controller: ,
                  ),
                ),
              ),

              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _stockStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.blue,
                      ),
                    );
                  }
                  final docList = snapshot.data!.docs
                      .map(
                        (doc) => Map<String, dynamic>.from(
                          doc.data() as Map<dynamic, dynamic>,
                        ),
                      )
                      .toList();
                  userHoldings = StockTransactionModel.toList(docList);
                  // userHoldings.forEach((element) {
                  //   if(!element.isBought!){
                  //      pastUserHoldings.add(element);
                  //   }
                  // });
                  pastUserHoldings = StockTransactionModel.toList(docList);
                  final Map<String, StockTransactionModel> userHoldingsMap = {};
                  userHoldings.sort((a,b) => a.transactionDate!.compareTo(b.transactionDate!));
                  for (final StockTransactionModel stockTransactionModel
                      in userHoldings) {
                    if (userHoldingsMap
                        .containsKey(stockTransactionModel.stockSymbol)) {
                      final val =
                          userHoldingsMap[stockTransactionModel.stockSymbol];
                      if (stockTransactionModel.isBought!) {
                        val!.quantity =
                            val.quantity! + stockTransactionModel.quantity!;
                      } else {
                        val!.quantity =
                            val.quantity! - stockTransactionModel.quantity!;
                      }

                      if (stockTransactionModel.transactionDate!
                          .isAfter(val.transactionDate!)) {
                        val
                          ..price = stockTransactionModel.price
                          ..transactionDate =
                              stockTransactionModel.transactionDate;
                      }
                      userHoldingsMap.update(val.stockSymbol!, (value) => val);
                      if (val.quantity == 0) {
                        userHoldingsMap.remove(val.stockSymbol);
                      }
                    } else {
                      userHoldingsMap.putIfAbsent(
                        stockTransactionModel.stockSymbol!,
                        () => stockTransactionModel,
                      );
                    }
                  }

                  final List<StockTransactionModel> groupedUserHoldings =
                    userHoldingsMap.values.toList();
                  // userHoldingsMap.values.forEach((element) {
                  //   print(element.toJson().toString());
                  // });
                  final dateFormat = DateFormat('dd MMM, yyyy');
                  final timeFormat = DateFormat('h:mm a');
                  return currentHolding == 0
                      ? CurrentHoldingStocks(
                          groupedUserHoldings: groupedUserHoldings,
                          timeFormat: timeFormat,
                          dateFormat: dateFormat,
                        )
                      : PastHoldingStocks(
                          groupedUserHoldings: pastUserHoldings,
                          timeFormat: timeFormat,
                          dateFormat: dateFormat,
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
