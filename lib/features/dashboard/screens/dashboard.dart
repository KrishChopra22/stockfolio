import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockfolio/features/analyze/screens/analyze_page.dart';
import 'package:stockfolio/features/auth/bloc/auth_cubit.dart';
import 'package:stockfolio/features/auth/screens/login_screen.dart';
import 'package:stockfolio/features/dashboard/repo/dashboard_repo.dart';
import 'package:stockfolio/features/home/screens/home_page.dart';
import 'package:stockfolio/features/news/screens/news_page.dart';
import 'package:stockfolio/features/stocks/screens/buy_sell.dart';
import 'package:stockfolio/features/watchlist/screens/watchlist_page.dart';
import 'package:stockfolio/models/stock_search_model.dart';
import 'package:stockfolio/models/stock_transaction_model.dart';
import 'package:stockfolio/models/user_model.dart';
import 'package:stockfolio/utils/Colors.dart';
import 'package:stockfolio/widgets/custom_search.dart';

import '../../../utils/utils.dart';
import '../../../widgets/custom_button.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({required this.userModel, super.key});

  final UserModel userModel;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedPage = 0;
  double centerContainerHeight = 0;
  bool showButtons = false;

  final _pageOptions = [
    const HomePage(),
    const AnalyzePage(),
    const WatchListPage(),
    const NewsPage(),
  ];

  DashboardRepository dashboardRepository = DashboardRepository();
  bool fetched = false;
  List<StockSearchModel> fullStocksList = <StockSearchModel>[];
  List<StockTransactionModel> userHoldings = <StockTransactionModel>[];

  @override
  void initState() {
    getStocksList();
    super.initState();
  }

  Future<void> getStocksList() async {
    fullStocksList = await dashboardRepository.fetchStocksList();
    setState(() {
      fetched = true;
    });
  }

  Future<void> getUserStocksList() async {
    userHoldings =
        await dashboardRepository.fetchStockTransactionListFromFirebase();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: AppColors.blue,
        foregroundColor: AppColors.white,
        leading: Padding(
          padding: const EdgeInsets.all(4),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  content: SizedBox(
                    height: 120,
                    child: Column(
                      children: [
                        const Text(
                          'Are you sure, you want to logout?',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        BlocListener<AuthCubit, AuthState>(
                          listener:
                              (BuildContext context, AuthState state) async {
                            if (state is AuthInitialState) {
                              await Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const LoginScreen(),
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: SizedBox(
                              height: 50,
                              width: double.maxFinite,
                              child: CustomButton(
                                text: 'LogOut',
                                onPressed: () async {
                                  await context.read<AuthCubit>().logOut();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.midBlue),
                borderRadius: BorderRadius.circular(80),
                image: DecorationImage(
                  image: NetworkImage(widget.userModel.profilePic!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Stock',
                style: TextStyle(color: Colors.white),
              ),
              TextSpan(
                text: 'Folio',
                style: TextStyle(color: AppColors.lightBlue),
              ),
            ],
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: GestureDetector(
              onTap: () async {
                fetched
                    ? await showSearch(
                        context: context,
                        delegate:
                            CustomSearchDelegate(stocksList: fullStocksList),
                      )
                    : null;
              },
              child: fetched
                  ? const Icon(
                      Icons.search_rounded,
                      size: 30,
                      color: Colors.white,
                    )
                  : const SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: _pageOptions[selectedPage],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        color: Colors.transparent,
        height: 50,
        width: double.maxFinite,
        child: FloatingActionButton.small(
          backgroundColor: Colors.white,
          onPressed: () async {
            await getUserStocksList();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BuySell(
                  userStocksList: userHoldings,
                  allStocksList: fullStocksList,
                ),
              ),
            );
          },
          tooltip: 'Add Trade',
          heroTag: 'Add_T',
          shape: const CircleBorder(),
          child: showButtons
              ? const Icon(
                  Icons.close_rounded,
                  size: 30,
                  color: AppColors.blue,
                )
              : const Icon(
                  Icons.add_rounded,
                  size: 32,
                  color: AppColors.blue,
                ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_line_chart_rounded, size: 24),
            label: 'Analyze',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmarks_rounded, size: 24),
            label: 'WatchList',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_rounded, size: 24),
            label: 'News',
          ),
        ],
        selectedItemColor: AppColors.blue,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        unselectedItemColor: AppColors.midBlue,
        currentIndex: selectedPage,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),
      // floatingActionButton: BlocListener<AuthCubit, AuthState>(
      //   listener: (BuildContext context, AuthState state) async {
      //     if (state is AuthInitialState) {
      //       await Navigator.of(context).pushAndRemoveUntil(
      //         MaterialPageRoute(
      //           builder: (BuildContext context) => const LoginScreen(),
      //         ),
      //         (route) => false,
      //       );
      //     }
      //     if (state is AuthErrorState && context.mounted) {
      //       showSnackBar(
      //         context,
      //         state.error,
      //       );
      //     }
      //   },
      //   child: CustomButton(
      //     text: 'LogOut',
      //     onPressed: () async {
      //       await context.read<AuthCubit>().logOut();
      //     },
      //   ),
      // ),
    );
  }
}
