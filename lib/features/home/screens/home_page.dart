import 'package:flutter/material.dart';
import 'package:stockfolio/features/dashboard/repo/dashboard_repo.dart';
import 'package:stockfolio/models/stock_transaction_model.dart';
import 'package:stockfolio/utils/Colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    getUserStocksList();
    _tabController = TabController(length: 2, vsync: this);
  }

  DashboardRepository dashboardRepository = DashboardRepository();
  List<StockTransactionModel> userHoldings = <StockTransactionModel>[];

  Future<void> getUserStocksList() async {
    userHoldings =
        await dashboardRepository.fetchStockTransactionListFromFirebase();
    setState(() {});
  }

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
                      setState(() {});
                      if (value == 0) {}
                    }, // controller: ,
                  ),
                ),
              ),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: userHoldings.length > 6 ? 6 : userHoldings.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 5,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          userHoldings[index].stockSymbol!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          userHoldings[index].exchangeName!,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        trailing: Text(
                          userHoldings[index].price!.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          // if (!context.mounted) {
                          //   return;
                          // }
                          // setState(() {
                          //   searchController.text =
                          //   filteredStocksList[index].stockSymbol!;
                          //   filteredStocksList.clear();
                          // }
                          // );
                        },
                      ),
                    ),
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
