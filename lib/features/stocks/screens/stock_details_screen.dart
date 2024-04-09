import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stockfolio/features/home/repo/home_repo.dart';
import 'package:stockfolio/models/stock_chart_model.dart';
import 'package:stockfolio/models/stock_data_model.dart';
import 'package:stockfolio/widgets/stock_chart_widget.dart';

class StockDetailsScreen extends StatefulWidget {
  const StockDetailsScreen({required this.stockData, super.key});

  final StockDataModel stockData;

  @override
  State<StockDetailsScreen> createState() => _StockDetailsScreenState();
}

class _StockDetailsScreenState extends State<StockDetailsScreen> {
  HomeRepository homeRepository = HomeRepository();
  List<StockChartModel> stockChartModelList = <StockChartModel>[];
  bool fetched = false;

  @override
  void initState() {
    getStockChartData();
    super.initState();
  }

  getStockChartData() async {
    stockChartModelList =
        await homeRepository.fetchStockChart(widget.stockData.symbol!);
    stockChartModelList = stockChartModelList.reversed.toList();
    setState(() {
      fetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 360,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(80),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Image.network(widget.stockData.imageUrl!),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 240,
                            child: Text(
                              '${widget.stockData.name!} (${widget.stockData.symbol!})',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                widget.stockData.exchange!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.blue.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          const Text(
                            'Current Price : ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '\$${widget.stockData.price!}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: widget.stockData.changesPercentage! > 0
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            widget.stockData.changesPercentage! > 0
                                ? r'$+ '
                                : r'$ ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: widget.stockData.changesPercentage! > 0
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${widget.stockData.change!}',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: widget.stockData.changesPercentage! > 0
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.stockData.changesPercentage! > 0
                                ? '(+ '
                                : '( ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: widget.stockData.changesPercentage! > 0
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${widget.stockData.changesPercentage!.toStringAsFixed(2)}%)',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: widget.stockData.changesPercentage! > 0
                                  ? Colors.green
                                  : Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: <Widget>[
                          Text(
                            'Volume : ${widget.stockData.volume!}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Open : \$${widget.stockData.open!}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Previous Close : \$${widget.stockData.previousClose}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Today's Highest : \$${widget.stockData.dayHigh}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: fetched
                    ? StockChartWidget(
                        stockChartList: stockChartModelList,
                      )
                    : const Text('Fetching Graph...'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
