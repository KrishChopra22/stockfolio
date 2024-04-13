import 'package:flutter/material.dart';
import 'package:stockfolio/widgets/custom_button.dart';
import 'package:stockfolio/widgets/custom_textfield.dart';

class Buy extends StatefulWidget {
  const Buy({super.key});

  @override
  State<Buy> createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  final TextEditingController buyTextController = TextEditingController();
  final TextEditingController quantityTextController = TextEditingController();
  final TextEditingController priceTextController = TextEditingController();
  final TextEditingController dateTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Center(child: Text('New Trade')),
              Padding(
                padding: const EdgeInsets.all(15),
                child: CustomTextField(
                  hintText: 'Stock Symbol',
                  icon: Icons.add,
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
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: CustomTextField(
                          hintText: 'Quantity',
                          icon: Icons.add,
                          inputType: TextInputType.text,
                          maxLines: 1,
                          controller: quantityTextController,
                          labelText: 'Stock Name',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: CustomTextField(
                          hintText: 'Price',
                          icon: Icons.add,
                          inputType: TextInputType.text,
                          maxLines: 1,
                          controller: priceTextController,
                          labelText: 'Stock Name',
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
