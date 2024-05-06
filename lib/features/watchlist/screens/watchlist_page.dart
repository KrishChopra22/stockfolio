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
        child: Column(
          children: [
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
                userWatchList
                    .sort((a, b) => b.dateAdded!.compareTo(a.dateAdded!));

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: userWatchList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final dateFormat = DateFormat('dd MMM, yyyy');
                    final timeFormat = DateFormat('h:mm a');
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
                            userWatchList[index].stockName!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blue,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '(${userWatchList[index].stockSymbol!})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.midBlue,
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
                                      color: AppColors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 120,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '₹ ${userWatchList[index].price!}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.blue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      timeFormat.format(
                                        userWatchList[index].dateAdded!,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.midBlue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      dateFormat.format(
                                        userWatchList[index].dateAdded!,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.midBlue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    watchListRepo.removeFromWatchList(
                                      userWatchList[index].stockSymbol!,
                                    );
                                  },
                                  icon: const Icon(Icons.delete_rounded),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {},
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
    );
  }
}
