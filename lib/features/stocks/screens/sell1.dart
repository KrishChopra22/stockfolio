import 'package:flutter/material.dart';
import 'package:stockfolio/features/stocks/screens/sell2.dart';
import 'package:stockfolio/widgets/custom_button.dart';
import 'package:stockfolio/widgets/custom_stock_card.dart';
import 'package:stockfolio/widgets/custom_textfield.dart';

class Sell extends StatefulWidget {
  const Sell({super.key});

  @override
  State<Sell> createState() => _SellState();
}

class _SellState extends State<Sell> {
  final TextEditingController searchController = TextEditingController();
  final stockSymbol = 'Apple Inc';
  final leftFieldName = 'Quantity';
  final leftFieldValue = 100;
  final rightFieldName = 'Profit/Loss';
  final rightFieldValue = '+ ₹500';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text('New Trade'),
            Padding(
              padding: const EdgeInsets.all(15),
              child: CustomTextField(
                hintText: 'Stock Symbol',
                icon: Icons.search,
                inputType: TextInputType.text,
                maxLines: 1,
                controller: searchController,
                labelText: 'Search',
              ),
            ),
            const Text('Current Holding'),
            Padding(
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SellNext(),
                      ),
                    );
                  },
                  child: CustomStockCard(
                    stockSymbol: stockSymbol,
                    leftFieldName: leftFieldName,
                    leftFieldValue: leftFieldValue,
                    rightFieldName: rightFieldName,
                    rightFieldValue: rightFieldValue,
                  ),
                ),
            ),
            Column(
              children: <Widget>[
                const Card(
                  color: Colors.blueGrey,
                ),
                CustomButton(text: 'Add Trade', onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
