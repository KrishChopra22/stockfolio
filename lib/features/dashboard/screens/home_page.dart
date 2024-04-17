import 'package:flutter/material.dart';
import 'package:stockfolio/features/home/screens/game_screen.dart';
import 'package:stockfolio/utils/Colors.dart';
import 'package:stockfolio/widgets/custom_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                    )
                  ],
                ),
              ),
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
                    Tab(
                      child: Text('Current Holdings'),
                    ),
                    Tab(
                      child: Text('Past Holdings'),
                    ),
                  ],
                  onTap: (value) {
                    if (value == 0) {
                      // Navigator.push(context,
                      //     // MaterialPageRoute(builder: (context)  ())
                      // );
                    }
                  }, // controller: ,
                ),
              ),
            ),
            CustomButton(
              text: 'Play Game',
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const GameScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
