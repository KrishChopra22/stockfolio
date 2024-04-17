import 'package:flutter/material.dart';
import 'package:stockfolio/features/dashboard/repo/dashboard_repo.dart';
import 'package:stockfolio/features/stocks/screens/stock_details_screen.dart';
import 'package:stockfolio/models/stock_search_model.dart';
import 'package:stockfolio/utils/Colors.dart';
import 'package:stockfolio/utils/utils.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  CustomSearchDelegate({required this.stocksList});

  final List<StockSearchModel> stocksList;
  DashboardRepository dashboardRepository = DashboardRepository();

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.clear_rounded),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<StockSearchModel> searchResults = stocksList
        .where(
          (StockSearchModel item) =>
              item.name!.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              splashColor: AppColors.blue,
              focusColor: AppColors.midBlue,
              child: ListTile(
                title: Text(searchResults[index].name!),
                subtitle: Text(searchResults[index].exchange!),
                trailing: Text(
                  searchResults[index].price!.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                onTap: () async {
                  final stockDataModel = await dashboardRepository
                      .fetchStockData(searchResults[index].symbol!);
                  if (stockDataModel.name == null) {
                    if (context.mounted) {
                      showSnackBar(
                        context,
                        "Sorry, this stock can't be processed",
                      );
                    }

                    return;
                  }
                  if (!context.mounted) {
                    return;
                  }
                  close(context, searchResults[index].name!);
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          StockDetailsScreen(stockData: stockDataModel),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<StockSearchModel> suggestionList = query.isEmpty
        ? <StockSearchModel>[]
        : stocksList
            .where(
              (StockSearchModel item) =>
                  item.name!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(suggestionList[index].name!),
          trailing: Transform.rotate(
            angle: 45,
            child: const Icon(
              Icons.arrow_back_rounded,
              size: 25,
            ),
          ),
          onTap: () {
            query = suggestionList[index].name!;
          },
        );
      },
    );
  }
}
