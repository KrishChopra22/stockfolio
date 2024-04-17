import 'package:flutter/material.dart';
import 'package:stockfolio/widgets/custom_button.dart';
import 'package:stockfolio/widgets/custom_textfield.dart';

class SellNext extends StatefulWidget {
  const SellNext({super.key});

  @override
  State<SellNext> createState() => _SellNextState();
}

class _SellNextState extends State<SellNext> {
  final TextEditingController buyTextController = TextEditingController();
  final TextEditingController quantityTextController = TextEditingController();
  final TextEditingController priceTextController = TextEditingController();
  final TextEditingController dateTextController = TextEditingController();

  int amount = 0;
  void calculateAmount(String num1, String num2) {

    setState(() {
      amount = int.parse(num1) * int.parse(num2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Stock'),
      ),
      body: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Center(
              child: Text(
                'Stock Name',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text('Owned'),
            ),
            const Card(),
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
                        inputType: TextInputType.text,
                        maxLines: 1,
                        controller: quantityTextController,
                        labelText: 'Quantity',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: CustomTextField(
                        hintText: 'Price',
                        icon: Icons.currency_rupee,
                        inputType: TextInputType.text,
                        maxLines: 1,
                        controller: priceTextController,
                        labelText: 'Price',
                        onChangedFunction: (value) {
                          calculateAmount(
                            quantityTextController.value.text,
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Amount: $amount',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
                  CustomButton(text: 'Add Trade', onPressed: () {}),
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
