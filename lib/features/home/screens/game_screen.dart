import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int totatltime = 500;
  double price = 100;
  bool startstop = false;
  double num = 0;
  double add = 100;
  late int news;
  double updownprice = 0;
  double startprice = 100;
  Color icon_text = Colors.white;
  String start_or_stop = 'START';
  double userwealth = 100000;
  IconData myicon = Icons.arrow_upward;
  Color iconcolor = const Color.fromARGB(255, 0, 233, 0);
  int number_of_shares = 0;
  int totalnumofshare = 0;
  int sharesbought = 0;
  late SnackBar snackBar;
  double high = 100;
  double low = 100;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void _showSnackBar() {
    snackBar = SnackBar(
      content: Text(
        'Success, Bought $totalnumofshare shares at the rate of ${price.toStringAsFixed(2)}, Shares owned: $sharesbought',
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
        'Success, Sold $totalnumofshare shares at the rate of ${price.toStringAsFixed(2)}, shares owned: $sharesbought',
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
        number_of_shares = userwealth ~/ startprice;
      } else if (num == 1) {}
    });
  }

  void changecolor(double diff) {
    if (diff >= 0) {
      setState(() {
        icon_text = const Color.fromARGB(255, 0, 233, 0);
        myicon = Icons.arrow_upward;
        iconcolor = const Color.fromARGB(255, 0, 233, 0);
      });
    } else {
      setState(() {
        myicon = Icons.arrow_downward;
        icon_text = const Color(0xffFF0000);
        iconcolor = const Color(0xffFF0000);
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
        start_or_stop = 'STOP';
      } else {
        start_or_stop = 'START';
      }
    });
  }

  void changeprice() {
    if (startstop) {
      Timer(Duration(milliseconds: totatltime), () {
        totatltime = 1800;
        if (startstop) {
          setState(() {
            final int news = Random().nextInt(10);
            switch (news) {
              case 0:
                add = add + getrandom();
                updownprice = add - startprice;
                changecolor(updownprice);
                price = add;

              case 1:
                add = add + getrandom();

                updownprice = add - startprice;
                changecolor(updownprice);
                price = add;
              case 2:
                add = add + 0.30;

                updownprice = add - startprice;
                changecolor(updownprice);
                price = add;
              case 3:
                add = add - .40;

                updownprice = add - startprice;
                changecolor(updownprice);
                price = add;
              case 4:
                add = add + getrandom();

                updownprice = add - startprice;
                changecolor(updownprice);
                price = add;
              case 5:
                add = add - .40;

                updownprice = add - startprice;
                changecolor(updownprice);
                price = add;
              case 6:
                add = add + getrandom();

                updownprice = add - startprice;
                changecolor(updownprice);
                price = add;
              case 7:
                add = add + getrandom();

                updownprice = add - startprice;
                changecolor(updownprice);
                price = add;
              case 8:
                add = add + getrandom();

                updownprice = add - startprice;
                changecolor(updownprice);
                price = add;
              case 9:
                add = add + 0.30;

                updownprice = add - startprice;
                changecolor(updownprice);
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
                      if (start_or_stop == 'START') {
                        setstatesws('START');
                        numberofshares(0);
                        startstop = true;
                        changeprice();
                      } else if (start_or_stop == 'STOP') {
                        startstop = false;
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
                      start_or_stop,
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
                              myicon,
                              color: iconcolor,
                            ),
                            iconSize: 40,
                            onPressed: null,
                          ),
                          Baseline(
                            baseline: 30,
                            baselineType: TextBaseline.alphabetic,
                            child: Text(
                              updownprice.toStringAsFixed(2),
                              style: TextStyle(
                                color: icon_text,
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
                    'Shares Owned : $sharesbought',
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
                            totalnumofshare = number_of_shares ~/ 3.4;
                          });
                        },
                        shape: Border.all(
                          width: 2,
                          color: const Color.fromARGB(255, 166, 170, 207),
                        ),
                        minWidth: MediaQuery.of(context).size.width / 9,
                        child: Text(
                          (number_of_shares / 3.4).toStringAsFixed(0),
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
                            totalnumofshare = number_of_shares ~/ 2.5;
                          });
                        },
                        minWidth: MediaQuery.of(context).size.width / 9.1,
                        shape: Border.all(
                          width: 2,
                          color: const Color.fromARGB(255, 166, 170, 207),
                        ),
                        child: Text(
                          (number_of_shares / 2.5).toStringAsFixed(0),
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
                            totalnumofshare = number_of_shares ~/ 1.4;
                          });
                        },
                        minWidth: MediaQuery.of(context).size.width / 9.1,
                        shape: Border.all(
                          width: 2,
                          color: const Color.fromARGB(255, 166, 170, 207),
                        ),
                        child: Text(
                          (number_of_shares / 1.4).toStringAsFixed(0),
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
                            totalnumofshare = sharesbought;
                          });
                        },
                        minWidth: MediaQuery.of(context).size.width / 9.1,
                        shape: Border.all(
                          width: 2,
                          color: const Color.fromARGB(255, 166, 170, 207),
                        ),
                        child: Text(
                          sharesbought.toStringAsFixed(0),
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
                          if (totalnumofshare > 1) {
                            setState(() {
                              totalnumofshare--;
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
                            totalnumofshare.toString(),
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
                            totalnumofshare++;
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
                        if (startstop) {
                          if (price * totalnumofshare <= userwealth) {
                            if (totalnumofshare > 0) {
                              setState(() {
                                userwealth =
                                    userwealth - (price * totalnumofshare);
                                sharesbought = sharesbought + totalnumofshare;
                                number_of_shares = userwealth ~/ price;
                                print(sharesbought);
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
                            const Color(0xffFF0000)),
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
                        if (startstop) {
                          if (totalnumofshare <= sharesbought) {
                            if (totalnumofshare > 0) {
                              setState(() {
                                userwealth =
                                    userwealth + (totalnumofshare * price);
                                sharesbought = sharesbought - totalnumofshare;
                                number_of_shares = userwealth ~/ price;
                                print(sharesbought);
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
              'Current Balance :   ₹${userwealth.toStringAsFixed(2)}',
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
