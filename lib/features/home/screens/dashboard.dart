import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockfolio/features/auth/bloc/auth_cubit.dart';
import 'package:stockfolio/features/auth/screens/login_screen.dart';
import 'package:stockfolio/features/home/repo/home_repo.dart';
import 'package:stockfolio/features/home/screens/game_screen.dart';
import 'package:stockfolio/models/stock_search_model.dart';
import 'package:stockfolio/models/user_model.dart';
import 'package:stockfolio/utils/Colors.dart';
import 'package:stockfolio/utils/utils.dart';
import 'package:stockfolio/widgets/custom_button.dart';
import 'package:stockfolio/widgets/custom_search.dart';

import '../../stocks/screens/buy.dart';
import '../../stocks/screens/buy_sell.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({required this.userModel, super.key});

  final UserModel userModel;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  HomeRepository homeRepository = HomeRepository();
  bool fetched = false;
  List<StockSearchModel> fullStocksList = <StockSearchModel>[];

  @override
  void initState() {
    getStocksList();
    super.initState();
  }

  Future<void> getStocksList() async {
    fullStocksList = await homeRepository.fetchStocksList();
    setState(() {
      fetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        title: const Text('StockFolio'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () async {
                  fetched
                      ? await showSearch(
                          context: context,
                          delegate:
                              CustomSearchDelegate(stocksList: fullStocksList),
                        )
                      : showSnackBar(
                          context,
                          "Please wait, we're fetching stocks",
                        );
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration:
                  BoxDecoration(
                    // boxShadow: <BoxShadow>[
                    //   BoxShadow(
                    //     color: Colors.grey,
                    //     offset: Offset.fromDirection(1, 2),
                    //     spreadRadius: 0.4,
                    //     blurRadius: 1,
                    //   ),
                    // ],
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.black87),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          fetched
                              ? '  Search Stocks/ETFs...'
                              : '  Initialising...',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(Icons.search_rounded),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Text(widget.userModel.uid!),
            const SizedBox(height: 20),
            Card(
              color: AppColors.lightBlue,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.02,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Invested ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text('Current Amount ',
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
                        Text('100000',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                          ),
                        ),
                        Text('100000',
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
                        Text('P/L: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text('+100',
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
                        Text('10%',
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
            CustomButton(
              text: 'Buy Sell',
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const BuySell(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: BlocListener<AuthCubit, AuthState>(
        listener: (BuildContext context, AuthState state) async {
          if (state is AuthInitialState) {
            await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => const LoginScreen(),
              ),
              (route) => false,
            );
          }
          if (state is AuthErrorState && context.mounted) {
            showSnackBar(
              context,
              state.error,
            );
          }
        },
        child: CustomButton(
          text: 'LogOut',
          onPressed: () async {
            await context.read<AuthCubit>().logOut();
          },
        ),
      ),
    );
  }
}
