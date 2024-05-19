import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stockfolio/models/stock_watchlist_model.dart';

class WatchListRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getWatchListStream() {
    final uid = _firebaseAuth.currentUser!.uid;
    final watchlistStream = _firebaseFirestore
        .collection('WatchList')
        .where('userId', isEqualTo: uid)
        .snapshots();
    return watchlistStream;
  }

  Future<void> removeFromWatchList(String stockSymbol) async {
    final uid = _firebaseAuth.currentUser!.uid;
    final query = _firebaseFirestore
        .collection('WatchList')
        .where('userId', isEqualTo: uid)
        .where('stockSymbol', isEqualTo: stockSymbol);
    await query.get().then(
          (querySnapshot) => querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
            print("$stockSymbol removed from watchList");
          }),
        );
  }

  Future<StockWatchListModel> addToWatchList(
    StockWatchListModel stockWatchListModel,
  ) async {
    final uid = _firebaseAuth.currentUser!.uid;
    await removeFromWatchList(stockWatchListModel.stockSymbol!);
    final StockWatchListModel finalStockTransaction =
        stockWatchListModel.copyWith(userId: uid);
    // uploading to database
    await _firebaseFirestore.collection('WatchList').add(
          finalStockTransaction.toJson(),
        );
    print("${stockWatchListModel.stockSymbol!} added to watchList");
    return finalStockTransaction;
  }
}
