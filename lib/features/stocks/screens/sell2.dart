import 'package:flutter/material.dart';
import 'package:stockfolio/features/dashboard/repo/dashboard_repo.dart';
import 'package:stockfolio/models/stock_transaction_model.dart';
import 'package:stockfolio/utils/Colors.dart';
import 'package:stockfolio/utils/utils.dart';
import 'package:stockfolio/widgets/custom_button.dart';
import 'package:stockfolio/widgets/custom_textfield.dart';

class SellNext extends StatefulWidget {
  const SellNext(
      {super.key,
      required this.selectedStockSymbol,
      required this.userStocksList,
      required this.selectedStockExchange});

  final String selectedStockSymbol;
  final String selectedStockExchange;
  final List<StockTransactionModel> userStocksList;

  @override
  State<SellNext> createState() => _SellNextState();
}

class _SellNextState extends State<SellNext> {
  final TextEditingController quantityTextController = TextEditingController();
  final TextEditingController priceTextController = TextEditingController();
  final TextEditingController dateTextController = TextEditingController();

  int totalHoldingQuantity = 0;
  double amount = 0;
  void calculateAmount(String quantity, String stockPrice) {
    if (quantity.isEmpty) {
      quantity = '0';
    }
    if (stockPrice.isEmpty) {
      stockPrice = '0';
    }
    setState(() {
      dateTextController.text = DateTime.now().toString();
      amount = int.parse(quantity) * double.parse(stockPrice);
      amount = double.parse(amount.toStringAsFixed(2));
    });
  }

  void computeQuantity() {
    for (final StockTransactionModel stm in widget.userStocksList) {
      if (stm.stockSymbol == widget.selectedStockSymbol) {
        if (stm.isBought!) {
          totalHoldingQuantity += stm.quantity!;
        } else {
          totalHoldingQuantity -= stm.quantity!;
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    computeQuantity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Stock'),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Text(
                  widget.selectedStockSymbol,
                  style: const TextStyle(fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Quantity Owned : $totalHoldingQuantity',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blue,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
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
                          icon: Icons.onetwothree_rounded,
                          inputType: TextInputType.number,
                          maxLines: 1,
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
                          icon: Icons.currency_rupee,
                          inputType: TextInputType.number,
                          maxLines: 1,
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
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 3,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
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
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomButton(
                      text: 'Sell',
                      onPressed: () async {
                        if (quantityTextController.text.isEmpty ||
                            priceTextController.text.isEmpty) {
                          showSnackBar(
                            context,
                            'Enter Stock Quantity and Selling Price to proceed',
                          );
                          return;
                        }
                        if (quantityTextController.text.isNotEmpty &&
                            int.parse(quantityTextController.text) >
                                totalHoldingQuantity) {
                          showSnackBar(
                            context,
                            'You cannot sell more than what you own!',
                          );
                          return;
                        }
                        final DashboardRepository dashboardRepository =
                            DashboardRepository();
                        final StockTransactionModel stockTransactionModel =
                            StockTransactionModel(
                          stockSymbol: widget.selectedStockSymbol,
                          userId: '',
                          price: double.parse(priceTextController.text),
                          quantity: int.parse(quantityTextController.text),
                          exchangeName: widget.selectedStockExchange,
                          isBought: false,
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
                          Navigator.of(context).pop();
                        } else {
                          showSnackBar(
                            context,
                            "Your trade wasn't processed, please retry!",
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
