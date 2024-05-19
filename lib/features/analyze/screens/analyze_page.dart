import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:stockfolio/features/dashboard/repo/dashboard_repo.dart';
import 'package:stockfolio/models/stock_transaction_model.dart';
import 'package:stockfolio/utils/Colors.dart';

class AnalyzePage extends StatefulWidget {
  const AnalyzePage({super.key});

  @override
  State<AnalyzePage> createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  Map<String, double> industryAnalysis = {};
  Map<String, double> sectorAnalysis = {};
  List<StockTransactionModel> userStocksList = [];
  List<StockTransactionModel> groupedUserHoldings = [];
  DashboardRepository dashboardRepository = DashboardRepository();
  final dateFormat = DateFormat('dd MMM, yyyy');
  final timeFormat = DateFormat('h:mm a');

  @override
  void initState() {
    super.initState();
    initStocksList();
  }

  Future<void> initStocksList() async {
    userStocksList =
        await dashboardRepository.fetchStockTransactionListFromFirebase();
    final Map<String, StockTransactionModel> userHoldingsMap = {};
    userStocksList.sort(
      (a, b) => a.transactionDate!.compareTo(b.transactionDate!),
    );

    for (final StockTransactionModel transaction in userStocksList) {
      final stockSymbol = transaction.stockSymbol;
      final isBuy = transaction.isBought ?? false;
      final transactionQuantity = transaction.quantity ?? 0;

      if (userHoldingsMap.containsKey(stockSymbol)) {
        var currentHolding = userHoldingsMap[stockSymbol];
        if (currentHolding != null) {
          // Pehale k sab transaction ka price calc hua
          final totalPrice =
              (currentHolding.price ?? 0) * (currentHolding.quantity ?? 0);
          // Abhi vale ka price calc hua
          final transactionAmount = transaction.price! * transactionQuantity;

          //Dono ko add kar do agar buy hai nai toh minus
          final double newTotalPrice;

          if (isBuy) {
            newTotalPrice = totalPrice + transactionAmount;
            currentHolding.quantity =
                (currentHolding.quantity ?? 0) + transactionQuantity;
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
            currentHolding.price = newTotalPrice /
                (currentHolding.quantity ?? 1); // Prevent division by zero
          } else {
            // Set price to 0 if quantity is 0
            currentHolding.price = 0;
          }
          if (currentHolding.quantity == 0) {
            userHoldingsMap.remove(stockSymbol);
          }
        }
      } else {
        userHoldingsMap.putIfAbsent(
          stockSymbol!,
          () => transaction,
        );
      }
    }
    groupedUserHoldings = userHoldingsMap.values.toList();
    initSectorChart();
  }

  void initSectorChart() {
    int totalQuantity = 0;
    for (var holding in groupedUserHoldings) {
      totalQuantity += holding.quantity!;
    }

    for (var holding in groupedUserHoldings) {
      if (industryAnalysis.containsKey(holding.industry)) {
        double val = industryAnalysis[holding.industry]! * totalQuantity / 100;
        industryAnalysis.update(
          holding.industry!,
          (value) => (val + holding.quantity!) * 100 / totalQuantity,
        );
      } else {
        industryAnalysis.putIfAbsent(
          holding.industry!,
          () => holding.quantity! * 100 / totalQuantity,
        );
      }

      if (sectorAnalysis.containsKey(holding.sector)) {
        double val = sectorAnalysis[holding.sector]! * totalQuantity / 100;
        sectorAnalysis.update(
          holding.sector!,
          (value) => (val + holding.quantity!) * 100 / totalQuantity,
        );
      } else {
        sectorAnalysis.putIfAbsent(
          holding.sector!,
          () => holding.quantity! * 100 / totalQuantity,
        );
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Sector Analysis',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              if (sectorAnalysis.isNotEmpty)
                PieChart(
                  animationDuration: const Duration(milliseconds: 1500),
                  dataMap: sectorAnalysis,
                  chartRadius: 200,
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValuesOutside: true,
                    showChartValuesInPercentage: true,
                  ),
                  legendOptions: const LegendOptions(
                    showLegendsInRow: true,
                    legendPosition: LegendPosition.bottom,
                  ),
                  chartLegendSpacing: 18,
                ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 2,
              ),
              const Padding(
                padding: EdgeInsets.all(4),
                child: Text(
                  'Industry Analysis',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              if (industryAnalysis.isNotEmpty)
                PieChart(
                  animationDuration: const Duration(milliseconds: 1500),
                  chartType: ChartType.ring,
                  dataMap: industryAnalysis,
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: false,
                    showChartValuesInPercentage: true,
                  ),
                  chartLegendSpacing: 24,
                ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                children: [
                  Text(
                    'Current Stocks in Portfolio -',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: groupedUserHoldings.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          groupedUserHoldings[index].stockSymbol!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              groupedUserHoldings[index].exchangeName!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.darkGrey,
                              ),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Industry : ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                                Text(
                                  groupedUserHoldings[index].industry!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Spacer(),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.blue,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 3,
                                    horizontal: 6,
                                  ),
                                  child: Text(
                                    groupedUserHoldings[index].sector!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        onTap: () {},
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
