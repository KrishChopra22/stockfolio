import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int totalTime = 500;
  double price = 100;
  bool startStop = false;
  double num = 0;
  double add = 100;
  late int news;
  double upDownPrice = 0;
  double startPrice = 100;
  Color iconText = Colors.white;
  String startOrStop = 'START';
  double userWealth = 100000;
  IconData myIcon = Icons.arrow_upward;
  Color iconColor = const Color.fromARGB(255, 0, 233, 0);
  int numberOfShares = 0;
  int totalNumOfShare = 0;
  int sharesBought = 0;
  late SnackBar snackBar;
  double high = 100;
  double low = 100;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnackBar() {
    snackBar = SnackBar(
      content: Text(
        '''Success, Bought $totalNumOfShare shares at the rate of ${price.toStringAsFixed(2)}, Shares owned: $sharesBought''',
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
        ),
      ),
      backgroundColor: const Color(0xff2B76C6),
      duration: const Duration(milliseconds: 1200),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showSnackBarsell() {
    snackBar = SnackBar(
      duration: const Duration(milliseconds: 1200),
      content: Text(
        '''Success, Sold $totalNumOfShare shares at the rate of ${price.toStringAsFixed(2)}, shares owned: $sharesBought''',
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
        ),
      ),
      backgroundColor: const Color(0xff2B76C6),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void numberofshares(int num) {
    setState(() {
      if (num == 0) {
        numberOfShares = userWealth ~/ startPrice;
      } else if (num == 1) {}
    });
  }

  void changecolor(double diff) {
    if (diff >= 0) {
      setState(() {
        iconText = const Color.fromARGB(255, 0, 233, 0);
        myIcon = Icons.arrow_upward;
        iconColor = const Color.fromARGB(255, 0, 233, 0);
      });
    } else {
      setState(() {
        myIcon = Icons.arrow_downward;
        iconText = const Color(0xffFF0000);
        iconColor = const Color(0xffFF0000);
      });
    }
  }

  double getrandom() {
    final int num = Random().nextInt(10);
    final List<dynamic> addnum = [
      0.10,
      -0.10,
      0.05,
      -.05,
      0.15,
      -.10,
      0.20,
      -.05,
      0.10,
      -.05,
    ];
    return addnum[num];
  }

  void setstatesws(String onorof) {
    setState(() {
      if (onorof == 'START') {
        startOrStop = 'STOP';
      } else {
        startOrStop = 'START';
      }
    });
  }

  void changeprice() {
    if (startStop) {
      Timer(Duration(milliseconds: totalTime), () {
        totalTime = 1800;
        if (startStop) {
          setState(() {
            final int news = Random().nextInt(10);
            switch (news) {
              case 0:
                add = add + getrandom();
                upDownPrice = add - startPrice;
                changecolor(upDownPrice);
                price = add;

              case 1:
                add = add + getrandom();

                upDownPrice = add - startPrice;
                changecolor(upDownPrice);
                price = add;
              case 2:
                add = add + 0.30;

                upDownPrice = add - startPrice;
                changecolor(upDownPrice);
                price = add;
              case 3:
                add = add - .40;

                upDownPrice = add - startPrice;
                changecolor(upDownPrice);
                price = add;
              case 4:
                add = add + getrandom();

                upDownPrice = add - startPrice;
                changecolor(upDownPrice);
                price = add;
              case 5:
                add = add - .40;

                upDownPrice = add - startPrice;
                changecolor(upDownPrice);
                price = add;
              case 6:
                add = add + getrandom();

                upDownPrice = add - startPrice;
                changecolor(upDownPrice);
                price = add;
              case 7:
                add = add + getrandom();

                upDownPrice = add - startPrice;
                changecolor(upDownPrice);
                price = add;
              case 8:
                add = add + getrandom();

                upDownPrice = add - startPrice;
                changecolor(upDownPrice);
                price = add;
              case 9:
                add = add + 0.30;

                upDownPrice = add - startPrice;
                changecolor(upDownPrice);
                price = add;
            }
            if (high < price) {
              high = price;
            } else if (low > price) {
              low = price;
            }
            changeprice();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_rounded,
            size: 30,
          ),
        ),
        title: const Text(
          'Demo Trading',
          style: TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.w500),
        ),
        // backgroundColor: const Color(0XFF1B1D38),
        elevation: 0,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (startOrStop == 'START') {
                        setstatesws('START');
                        numberofshares(0);
                        startStop = true;
                        changeprice();
                      } else if (startOrStop == 'STOP') {
                        startStop = false;
                        setstatesws('STOP');
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black87),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    child: Text(
                      startOrStop,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0XFF1B1D38),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 44, 28, 87),
              border: Border.all(width: 2, color: Colors.white),
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.all(12),
            height: MediaQuery.of(context).size.height / 3,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                const Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'XYZ Stock Ltd.',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 36,
                          color: Color.fromARGB(255, 166, 170, 207),
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Wrap(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            '₹${price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              myIcon,
                              color: iconColor,
                            ),
                            iconSize: 40,
                            onPressed: null,
                          ),
                          Baseline(
                            baseline: 30,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              upDownPrice.toStringAsFixed(2),
                              style: TextStyle(
                                color: iconText,
                                fontFamily: 'Roboto',
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.8,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            const Text(
                              'Lowest',
                              style: TextStyle(
                                color: Color.fromARGB(255, 166, 170, 207),
                                fontFamily: 'Roboto',
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              low.toStringAsFixed(2),
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: <Widget>[
                            const Text(
                              'Highest',
                              style: TextStyle(
                                color: Color.fromARGB(255, 166, 170, 207),
                                fontFamily: 'Roboto',
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              high.toStringAsFixed(2),
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                fontSize: 24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            height: MediaQuery.of(context).size.height / 2.5,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 44, 28, 87),
              border: Border.all(
                width: 2,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(padding: EdgeInsets.only(top: 10)),
                Flexible(
                  child: Text(
                    'Shares Owned : $sharesBought',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            totalNumOfShare = numberOfShares ~/ 3.4;
                          });
                        },
                        shape: Border.all(
                          width: 2,
                          color: const Color.fromARGB(255, 166, 170, 207),
                        ),
                        minWidth: MediaQuery.of(context).size.width / 9,
                        child: Text(
                          (numberOfShares / 3.4).toStringAsFixed(0),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 166, 170, 207),
                            fontFamily: 'OpenSans',
                            fontSize: 20,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            totalNumOfShare = numberOfShares ~/ 2.5;
                          });
                        },
                        minWidth: MediaQuery.of(context).size.width / 9.1,
                        shape: Border.all(
                          width: 2,
                          color: const Color.fromARGB(255, 166, 170, 207),
                        ),
                        child: Text(
                          (numberOfShares / 2.5).toStringAsFixed(0),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 166, 170, 207),
                            fontFamily: 'OpenSans',
                            fontSize: 20,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            totalNumOfShare = numberOfShares ~/ 1.4;
                          });
                        },
                        minWidth: MediaQuery.of(context).size.width / 9.1,
                        shape: Border.all(
                          width: 2,
                          color: const Color.fromARGB(255, 166, 170, 207),
                        ),
                        child: Text(
                          (numberOfShares / 1.4).toStringAsFixed(0),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 166, 170, 207),
                            fontFamily: 'OpenSans',
                            fontSize: 20,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            totalNumOfShare = sharesBought;
                          });
                        },
                        minWidth: MediaQuery.of(context).size.width / 9.1,
                        shape: Border.all(
                          width: 2,
                          color: const Color.fromARGB(255, 166, 170, 207),
                        ),
                        child: Text(
                          sharesBought.toStringAsFixed(0),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 166, 170, 207),
                            fontFamily: 'OpenSans',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.84,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      MaterialButton(
                        onPressed: () {
                          if (totalNumOfShare > 1) {
                            setState(() {
                              totalNumOfShare--;
                            });
                          }
                        },
                        color: const Color(0xffFF0000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: const BorderSide(
                            color: Color(0xffFF0000),
                          ),
                        ),
                        child: const Icon(
                          Icons.expand_more,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        width: MediaQuery.of(context).size.width / 3.6,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Text(
                            totalNumOfShare.toString(),
                            style: const TextStyle(
                              color: Color(0xff1B1D38),
                              fontFamily: 'OpenSans',
                              wordSpacing: 1.5,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            totalNumOfShare++;
                          });
                        },
                        color: const Color.fromARGB(255, 1, 208, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 1, 208, 1),
                          ),
                        ),
                        child: const Icon(
                          Icons.expand_less,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        if (startStop) {
                          if (price * totalNumOfShare <= userWealth) {
                            if (totalNumOfShare > 0) {
                              setState(() {
                                userWealth =
                                    userWealth - (price * totalNumOfShare);
                                sharesBought = sharesBought + totalNumOfShare;
                                numberOfShares = userWealth ~/ price;
                                if (kDebugMode) {
                                  print(sharesBought);
                                }
                                _showSnackBar();
                              });
                            } else {
                              setState(() {
                                snackBar = const SnackBar(
                                  duration: Duration(milliseconds: 900),
                                  content: Text(
                                    'Number of shares must be greater than 0',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                  backgroundColor: Color(0xff2B76C6),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            }
                          } else {
                            setState(() {
                              snackBar = const SnackBar(
                                duration: Duration(milliseconds: 900),
                                content: Text(
                                  'Cannot buy because of low Bank Balance',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                                backgroundColor: Color(0xff2B76C6),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            });
                          }
                        } else {
                          setState(() {
                            snackBar = const SnackBar(
                              duration: Duration(milliseconds: 900),
                              content: Text(
                                'Press Start button to Buy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                              backgroundColor: Color(0xff2B76C6),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        }
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xffFF0000),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      child: const Text(
                        '  BUY  ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (startStop) {
                          if (totalNumOfShare <= sharesBought) {
                            if (totalNumOfShare > 0) {
                              setState(() {
                                userWealth =
                                    userWealth + (totalNumOfShare * price);
                                sharesBought = sharesBought - totalNumOfShare;
                                numberOfShares = userWealth ~/ price;
                                if (kDebugMode) {
                                  print(sharesBought);
                                }
                                _showSnackBarsell();
                              });
                            } else {
                              setState(() {
                                snackBar = const SnackBar(
                                  duration: Duration(milliseconds: 900),
                                  content: Text(
                                    'Number of shares must be greater than 0',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                  backgroundColor: Color(0xff2B76C6),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              });
                            }
                          } else {
                            setState(() {
                              snackBar = const SnackBar(
                                duration: Duration(milliseconds: 900),
                                content: Text(
                                  'Cannot sell more stocks than you own',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                                backgroundColor: Color(0xff2B76C6),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            });
                          }
                        } else {
                          setState(() {
                            snackBar = const SnackBar(
                              duration: Duration(milliseconds: 900),
                              content: Text(
                                'Press Start button to Sell',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                ),
                              ),
                              backgroundColor: Color(0xff2B76C6),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          });
                        }
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 1, 208, 1),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      child: const Text(
                        '  SELL  ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          MaterialButton(
            minWidth: MediaQuery.of(context).size.width * .95,
            height: 50,
            splashColor: const Color(0xff1B1D38),
            onPressed: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(
                color: Colors.white,
              ),
            ),
            child: Text(
              'Current Balance :   ₹${userWealth.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xffffffff),
                fontSize: 20,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 1)),
        ],
      ),
    );
  }
}
