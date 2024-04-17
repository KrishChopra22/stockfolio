import 'package:flutter/material.dart';
import 'package:stockfolio/widgets/custom_button.dart';
import 'package:stockfolio/widgets/custom_textfield.dart';

class Buy extends StatefulWidget {
  const Buy({super.key});

  @override
  State<Buy> createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  int amount = 0;
  void calculateAmount(String num1, String num2) {

    setState(() {
      amount = int.parse(num1) * int.parse(num2);
    });
  }

  final TextEditingController buyTextController = TextEditingController();
  final TextEditingController quantityTextController = TextEditingController();
  final TextEditingController priceTextController = TextEditingController();
  final TextEditingController dateTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool NSE = false;
    bool BSE = false;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(15),
                child: CustomTextField(
                  hintText: 'Stock Symbol',
                  inputType: TextInputType.text,
                  maxLines: 1,
                  controller: buyTextController,
                  labelText: 'Stock Name',
                ),
              ),
              Container(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: CustomTextField(
                          hintText: 'Quantity',
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
                          inputType: TextInputType.text,
                          maxLines: 1,
                          controller: priceTextController,
                          labelText: 'Price',
                          onChangedFunction: (value) {
                            calculateAmount(
                                quantityTextController.value.text, value,);
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
              Text('Amount : $amount'),
              ListTile(
                title: const Text('NSE'),
                leading: Radio<bool>(
                  value: true,
                  groupValue: NSE,
                  onChanged: (value) {
                    NSE = value!;
                  },
                ),
              ),
              ListTile(
                title: const Text('BSE'),
                leading: Radio<bool>(
                  value: true,
                  groupValue: NSE,
                  onChanged: (value) {
                    BSE = value!;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: CustomButton(text: 'Add Trade', onPressed: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
