import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stockfolio/features/watchlist/repo/watchlist_repo.dart';
import 'package:stockfolio/models/stock_watchlist_model.dart';
import 'package:stockfolio/utils/Colors.dart';

class WatchListPage extends StatefulWidget {
  const WatchListPage({super.key});

  @override
  State<WatchListPage> createState() => _WatchListPageState();
}

class _WatchListPageState extends State<WatchListPage> {
  final WatchListRepository watchListRepo = WatchListRepository();
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _watchlistStream;
  List<StockWatchListModel> userWatchList = [];

  Future<void> getWatchListStream() async {
    _watchlistStream = watchListRepo.getWatchListStream();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getWatchListStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("My Watchlist",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _watchlistStream,
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
                  userWatchList = StockWatchListModel.toList(docList);
                  userWatchList.sort((a, b) => b.dateAdded!.compareTo(a.dateAdded!));

                  return userWatchList.isEmpty ?
                  Expanded(
                    child: Center(
                        child: Text(
                          "No Stocks Added to watchlist",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: AppColors.darkGrey,
                    ),)),
                  ) :
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: userWatchList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = userWatchList[index];
                      final dateFormat = DateFormat('dd MMM, yyyy');
                      final timeFormat = DateFormat('h:mm a');
                      print(item.stockSymbol);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        child: Dismissible(
                          key: UniqueKey(),
                          background: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            setState(() {
                              watchListRepo.removeFromWatchList(
                                  userWatchList[index].stockSymbol!);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.stockName} deleted'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.lightBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(

                              title: Text(
                                userWatchList[index].stockName!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '(${userWatchList[index].stockSymbol!})',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.darkGrey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        userWatchList[index].exchangeName!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.darkGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // trailing: Container(
                              //   color: Colors.red,
                              //   child: Row(
                              //     children: [
                              //       Column(
                              //         crossAxisAlignment: CrossAxisAlignment.end,
                              //         mainAxisAlignment: MainAxisAlignment.center,
                              //         children: [
                              //           Text(
                              //             '₹ ${userWatchList[index].price!.toStringAsFixed(2)}',
                              //             style: const TextStyle(
                              //               fontSize: 14,
                              //               color: AppColors.black,
                              //               fontWeight: FontWeight.w600,
                              //             ),
                              //           ),
                              //           // const Spacer(),
                              //           // Text(
                              //           //   timeFormat.format(
                              //           //     userWatchList[index].dateAdded!,
                              //           //   ),
                              //           //   style: const TextStyle(
                              //           //     fontSize: 11,
                              //           //     color: AppColors.midBlue,
                              //           //     fontWeight: FontWeight.w500,
                              //           //   ),
                              //           // ),
                              //           // Text(
                              //           //   dateFormat.format(
                              //           //     userWatchList[index].dateAdded!,
                              //           //   ),
                              //           //   style: const TextStyle(
                              //           //     fontSize: 11,
                              //           //     color: AppColors.midBlue,
                              //           //     fontWeight: FontWeight.w500,
                              //           //   ),
                              //           // ),
                              //         ],
                              //       ),
                              //       SizedBox(
                              //         width: 10,
                              //       ),
                              //       IconButton(
                              //         onPressed: () {
                              //           watchListRepo.removeFromWatchList(
                              //             userWatchList[index].stockSymbol!,
                              //           );
                              //         },
                              //         icon: const Icon(Icons.delete_rounded),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              trailing: Text(
                                '₹ ${userWatchList[index].price!.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onTap: () {},
                            ),
                          ),
                        ),
                      );
                    },
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
