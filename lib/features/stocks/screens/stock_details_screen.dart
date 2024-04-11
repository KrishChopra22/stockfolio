import 'package:fk_toggle/fk_toggle.dart';
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

    final OnSelected selected = ((index, instance) {
      // ScaffoldMessenger.of(context).hideCurrentSnackBar();
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text('Select $index, toggle ${instance.labels[index]}')));
      //if index ==1 redirect ...
      print('Select $index, toggle ${instance.labels[index]}');
    });
    return Scaffold(
        body:
        SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                ),
          
                Text('${widget.stockData.symbol}'),
                Text('${widget.stockData.name}'),
                Text('${widget.stockData.exchange}'),
                Text('${widget.stockData.price}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${widget.stockData.change}          '),
                    Text('${widget.stockData.changesPercentage}'),
                  ],
                ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    color: Color(0xffD9D9D9),
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width - 30,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: MediaQuery.of(context).size.width * 0.07,
                          bottom: MediaQuery.of(context).size.height * 0.02,
                          right: MediaQuery.of(context).size.width * 0.07,
                        ),
                        child:
                        Column(
                          children: [
                            Text('Open: ${widget.stockData.open}'),
                            Text('Prev Close: ${widget.stockData.previousClose}'),
                            Text('Volume: ${widget.stockData.volume}'),
                            Text('P/E: ${widget.stockData.pe}'),
          
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text('dayLow'),
                                    Text('${widget.stockData.dayLow}'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('dayHigh'),
                                    Text('${widget.stockData.dayHigh}'),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          
          
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FkToggle(
                      height: MediaQuery.of(context).size.height / 20,
                      width: 180,
                      labels: const ['Current Holdings', 'Past Holdings'],
                      onSelected: selected
                  ),
                ),
              Container(
                          height: 400,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
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
        )

    );
  }
}
