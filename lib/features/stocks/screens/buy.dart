import 'package:flutter/material.dart';
import 'package:stockfolio/features/dashboard/repo/dashboard_repo.dart';
import 'package:stockfolio/models/stock_search_model.dart';
import 'package:stockfolio/models/stock_transaction_model.dart';
import 'package:stockfolio/utils/utils.dart';
import 'package:stockfolio/widgets/custom_button.dart';
import 'package:stockfolio/widgets/custom_textfield.dart';

import '../../../utils/Colors.dart';

class Buy extends StatefulWidget {
  const Buy({super.key, required this.allStocksList});

  final List<StockSearchModel> allStocksList;

  @override
  State<Buy> createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  double amount = 0;
  String searchText = '';
  void calculateAmount(String quantity, String stockPrice) {
    if (quantity.isEmpty) {
      quantity = '0';
    }
    if (stockPrice.isEmpty) {
      stockPrice = '0';
    }
    setState(() {
      amount = int.parse(quantity) * double.parse(stockPrice);
      amount = double.parse(amount.toStringAsFixed(2));
    });
  }

  List<StockSearchModel> filteredStocksList = [];

  final TextEditingController buyTextController = TextEditingController();
  String selectedStockSymbol = '';
  final TextEditingController quantityTextController = TextEditingController();
  final TextEditingController priceTextController = TextEditingController();
  final TextEditingController dateTextController = TextEditingController();
  final TextEditingController exchangeTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    onTapOutside: (PointerDownEvent event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    showCursor: true,
                    onChanged: (value) {
                      searchText = value;
                      if (searchText.length > 3) {
                        setState(() {
                          filteredStocksList = widget.allStocksList
                              .where(
                                (stock) => stock.name!
                                    .toLowerCase()
                                    .contains(searchText.toLowerCase()),
                              )
                              .toList();
                        });
                      } else {
                        setState(() {
                          filteredStocksList.clear();
                        });
                      }
                    },
                    cursorColor: AppColors.black,
                    controller: buyTextController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: AppColors.blue,
                        ),
                        child: const Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      suffixIcon: const Icon(
                        Icons.expand_circle_down_rounded,
                        size: 20,
                        color: AppColors.blue,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.black,
                        ),
                      ),
                      hintText: 'Enter Stock Name',
                      labelText: 'Stock Name',
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w300,
                        color: AppColors.blue,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      fillColor: Colors.transparent,
                      filled: true,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredStocksList.length > 5
                      ? 5
                      : filteredStocksList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 5,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            filteredStocksList[index].name!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            filteredStocksList[index].exchange!,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          trailing: Text(
                            filteredStocksList[index].price!.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            if (!context.mounted) {
                              return;
                            }
                            setState(() {
                              buyTextController.text =
                                  filteredStocksList[index].name!;
                              selectedStockSymbol =
                                  filteredStocksList[index].symbol!;

                              exchangeTextController.text =
                                  filteredStocksList[index].exchange!;
                              quantityTextController.text = '1';
                              priceTextController.text =
                                  filteredStocksList[index].price!.toString();
                              dateTextController.text =
                                  DateTime.now().toString();
                              filteredStocksList.clear();
                            });
                            calculateAmount(
                              quantityTextController.text,
                              priceTextController.text,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: CustomTextField(
                            hintText: 'Quantity',
                            inputType: TextInputType.number,
                            maxLines: 1,
                            icon: Icons.onetwothree_rounded,
                            controller: quantityTextController,
                            labelText: 'Quantity',
                            onChangedFunction: (value) {
                              if (value.isEmpty) {
                                value = '0';
                              }
                              calculateAmount(
                                value,
                                priceTextController.value.text,
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: CustomTextField(
                            hintText: 'Price',
                            inputType: TextInputType.number,
                            maxLines: 1,
                            icon: Icons.currency_rupee_rounded,
                            controller: priceTextController,
                            labelText: 'Price',
                            onChangedFunction: (value) {
                              if (value.isEmpty) {
                                value = '0';
                              }
                              calculateAmount(
                                quantityTextController.text,
                                value,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 3,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CustomTextField(
                      hintText: '',
                      icon: Icons.type_specimen_rounded,
                      inputType: TextInputType.datetime,
                      maxLines: 1,
                      isEnabled: false,
                      controller: exchangeTextController,
                      labelText: 'Exchange',
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 3,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: CustomTextField(
                      hintText: '',
                      icon: Icons.date_range,
                      inputType: TextInputType.datetime,
                      maxLines: 1,
                      isEnabled: false,
                      controller: dateTextController,
                      labelText: 'Date',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Total Amount : $amount',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blue,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: CustomButton(
                    text: 'Buy',
                    onPressed: () async {
                      if (quantityTextController.text.isEmpty ||
                          buyTextController.text.isEmpty ||
                          priceTextController.text.isEmpty) {
                        showSnackBar(
                          context,
                          'Enter Stock Name, Quantity and Price to proceed',
                        );
                        return;
                      }
                      final DashboardRepository dashboardRepository =
                          DashboardRepository();
                      final StockTransactionModel stockTransactionModel =
                          StockTransactionModel(
                        stockSymbol: selectedStockSymbol,
                        userId: '',
                        price: double.parse(priceTextController.text),
                        quantity: int.parse(quantityTextController.text),
                        exchangeName: exchangeTextController.text,
                        isBought: true,
                        transactionDate: DateTime.now(),
                      );
                      final response = await dashboardRepository
                          .saveStockTransactionToFirebase(
                        stockTransaction: stockTransactionModel,
                      );
                      if (response.userId!.isNotEmpty) {
                        showSnackBar(
                          context,
                          'Your trade was processed successfully!',
                        );
                        Navigator.of(context).pop();
                      } else {
                        showSnackBar(
                          context,
                          "Your trade wasn't processed, please retry!",
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
