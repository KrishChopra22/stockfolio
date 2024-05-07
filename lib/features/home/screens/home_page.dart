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
    getUserStocksStream();
  }

  DashboardRepository dashboardRepository = DashboardRepository();
  List<StockTransactionModel> userHoldings = <StockTransactionModel>[];
  List<StockTransactionModel> pastUserHoldings = <StockTransactionModel>[];
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _stockStream;

  Future<void> getUserStocksStream() async {
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
                  pastUserHoldings = StockTransactionModel.toList(docList);
                  final Map<String, StockTransactionModel> userHoldingsMap = {};
                  userHoldings.sort((a, b) =>
                      a.transactionDate!.compareTo(b.transactionDate!),);
                  // for (final StockTransactionModel stockTransactionModel in userHoldings) {
                  //   if (userHoldingsMap.containsKey(stockTransactionModel.stockSymbol)) {
                  //     final val = userHoldingsMap[stockTransactionModel.stockSymbol];
                  //     if (stockTransactionModel.isBought!) {
                  //       val!.quantity = val.quantity! + stockTransactionModel.quantity!;
                  //     } else {
                  //       val!.quantity = val.quantity! - stockTransactionModel.quantity!;
                  //     }
                  //
                  //     // Calc Amount
                  //     val.price = stockTransactionModel.price ;
                  //     // if (stockTransactionModel.transactionDate!.isAfter(val.transactionDate!)) {
                  //     //   val..price = stockTransactionModel.price as double?..transactionDate = stockTransactionModel.transactionDate;
                  //     // }
                  //     userHoldingsMap.update(val.stockSymbol!, (value) => val);
                  //     if (val.quantity == 0) {
                  //       userHoldingsMap.remove(val.stockSymbol);
                  //     }
                  //   } else {
                  //     userHoldingsMap.putIfAbsent(
                  //       stockTransactionModel.stockSymbol!,
                  //       () => stockTransactionModel,
                  //     );
                  //   }
                  //   //Amount / QTY
                  // }

                  for (final StockTransactionModel transaction in userHoldings) {
                    final stockSymbol = transaction.stockSymbol;
                    final isBuy = transaction.isBought ?? false;
                    final transactionQuantity = transaction.quantity ?? 0;

                    if (userHoldingsMap.containsKey(stockSymbol)) {
                      var currentHolding = userHoldingsMap[stockSymbol];
                      if (currentHolding != null) {


                        // Pehale k sab transaction ka price calc hua
                        final totalPrice = (currentHolding.price ?? 0) * (currentHolding.quantity ?? 0);
                        // Abhi vale ka price calc hua
                        final transactionAmount = transaction.price! * transactionQuantity;

                        // print('${stockSymbol}        ');
                        // print('${totalPrice}         ${currentHolding.price}  * ${currentHolding.quantity}');
                        // print('$transactionAmount     ${transaction.price} * ${transactionQuantity}');


                        //Dono ko add kar do agar buy hai nai toh minus
                        final newTotalPrice ;



                        if (isBuy) {
                          newTotalPrice = totalPrice + transactionAmount;
                          currentHolding.quantity = (currentHolding.quantity ?? 0) + transactionQuantity;
                        } else {
                          newTotalPrice = totalPrice - transactionAmount;
                          final currentQuantity = currentHolding.quantity ?? 0;
                          if (currentQuantity >= transactionQuantity) {
                            currentHolding.quantity = currentQuantity - transactionQuantity;
                          } else {
                            print("Sold More than Owned");
                          }
                        }

                        // Update the price as the average price
                        if (currentHolding.quantity != 0) {
                          currentHolding.price = newTotalPrice / (currentHolding.quantity ?? 1); // Prevent division by zero
                        } else {
                          // Set price to 0 if quantity is 0
                          currentHolding.price = 0;
                        }
                        if (currentHolding.quantity == 0) {
                          userHoldingsMap.remove(stockSymbol);
                        }
                      }
                    } else {
                          userHoldingsMap.putIfAbsent( stockSymbol!,
                            () => transaction,
                          );
                    }
                  }



                  final List<StockTransactionModel> groupedUserHoldings = userHoldingsMap.values.toList();
                  //Calc total Invested
                  double totalInvestedAmount = 0.0;
                  for (var transaction in groupedUserHoldings) {
                    var amt = transaction.price! * transaction.quantity!;
                    totalInvestedAmount += amt;
                  }

                  final currentAmount = 10000; // TODO Calc from API Data

                  final PL = currentAmount - totalInvestedAmount;
                  final PLpercent = (PL / totalInvestedAmount * 100).toStringAsFixed(2);
                  final dateFormat = DateFormat('dd MMM, yyyy');
                  final timeFormat = DateFormat('h:mm a');
                  return Column(
                    children: [

                      const SizedBox(height: 20),
                      Card(
                        color: AppColors.lightBlue,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.05,
                            vertical: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: Column(
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
                                    totalInvestedAmount.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    '10000',
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
                                    PL!<0 ?
                                    '${PL.toString()}' : '+${PL.toString()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18,
                                      color:
                                      PL! < 0 ? Colors.red : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    PL!<0 ?
                                    '${PLpercent.toString()} %' : '+${PLpercent.toString()} %',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color:
                                      PL!<0 ? Colors.red : Colors.green,
                                    ),

                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
                      if (currentHolding == 0) CurrentHoldingStocks(
                      groupedUserHoldings: groupedUserHoldings,
                        timeFormat: timeFormat,
                        dateFormat: dateFormat,
                      ) else PastHoldingStocks(
                      groupedUserHoldings: pastUserHoldings,
                      timeFormat: timeFormat,
                      dateFormat: dateFormat,
                      )
                    ],
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
