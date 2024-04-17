import 'package:fk_toggle/fk_toggle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stockfolio/features/home/repo/home_repo.dart';
import 'package:stockfolio/models/stock_chart_model.dart';
import 'package:stockfolio/models/stock_data_model.dart';
import 'package:stockfolio/widgets/stock_chart_widget.dart';

import '../../../utils/Colors.dart';
import 'CandleStickLine.dart';

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

  Future<void> getStockChartData() async {
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
            children: [
              Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
              ),
              Text('${widget.stockData.symbol}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
              ),
              Text('${widget.stockData.name}',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),),
              Text('${widget.stockData.exchange}'),
              Text('${widget.stockData.price}',
                style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('${widget.stockData.change}',
                      style: TextStyle(
                      color: widget.stockData.change! < 0 ? Colors.red : Colors.green,
                    ),
                    ),
                    Text('${widget.stockData.changesPercentage?.toStringAsFixed(2)}%',
                      style: TextStyle(
                    color: widget.stockData.change! < 0 ? Colors.red : Colors.green,
                    ),),
                  ],
                ),
              ),
              Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                color: AppColors.lightBlue,
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Padding(

                  padding: EdgeInsets.symmetric(
                    horizontal:MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Open: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Text('${widget.stockData.open}'),

                        ],
                      ),
                      Row(
                        children: [
                          Text('Previous Close: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Text('${widget.stockData.previousClose}'),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Volume: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Text('${widget.stockData.volume}'),
                        ],
                      ),
                      Row(
                        children: [
                          Text('P/E: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Text('${widget.stockData.pe}'),
                        ],
                      ),
                      Divider(
                        color: Colors.black, // Specify the color of the divider
                      ),
                      Text('Day\'s Range',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Text('Low'),
                              Text('${widget.stockData.dayLow}'),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('High'),
                              Text('${widget.stockData.dayHigh}'),
                            ],
                          ),
                        ],
                      ),
                      CandlestickChart(
                        low: widget.stockData.dayLow!.toDouble(),
                        high: widget.stockData.dayHigh!.toDouble(),
                        open: widget.stockData.open!.toDouble(),
                        close: widget.stockData.previousClose!.toDouble(),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add_circle_outline, color: AppColors.blue),
                    label: const Text(
                      'See More Details',
                      style: TextStyle(color: AppColors.blue),
                    ),
                  ),

                  TextButton.icon(
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                    icon: Icon(Icons.bar_chart, color: AppColors.blue), // Add your icon here
                    label: const Text(
                      'See Graph',
                      style: TextStyle(color: AppColors.blue),
                    ),
                  ),
                ],
              ),


              DefaultTabController(
                length: 2,
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TabBar(
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50), // Creates border
                        color: Colors.black),
                    labelColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(child: Text('Current Holdings'),
                      ),
                      Tab(child: Text('Past Holdings'),),
                    ],
                    onTap: (value){
                      if(value==0){
                        // Navigator.push(context,
                        //     // MaterialPageRoute(builder: (context)  ())
                        // );
                      }
                    },// controller: ,
                  ),
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
      ),
    );
  }

  void onSelected(int index, FkToggle instance) {
    // ScaffoldMessenger.of(context).hideCurrentSnackBar();
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text('Select $index, toggle ${instance.labels[index]}')));
    //if index ==1 redirect ...
    if (kDebugMode) {
      print('Select $index, toggle ${instance.labels[index]}');
    }
  }
}
