import 'package:fk_toggle/fk_toggle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stockfolio/features/buy_sell/screens/sellSearch.dart';
import 'package:stockfolio/widgets/custom_button.dart';
import 'package:stockfolio/widgets/custom_textfield.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

class Buy extends StatefulWidget {
  const Buy({Key? key}) : super(key: key);

  @override
  State<Buy> createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  final buyTextController = TextEditingController();
  final quantityTextController = TextEditingController();
  final priceTextController = TextEditingController();
  final dateTextController = TextEditingController();
  int amount = 0;
  void calculateAmount(String num1, String num2){
    print("inside amount");
    setState(() {
      amount = int.parse(num1)*int.parse(num2);
    });
  }


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
            children: [
              const Center(
                child: Text(
                  'New Trade',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FkToggle(
                  selectedColor: Colors.black,
                    height: MediaQuery.of(context).size.height / 20,
                    width: 200,
                    labels: const <String>['Buy', 'Sell'],
                    onSelected: (value,toggle){
                      if(value==1){
                        print("sell selected");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Sell())
                        );
                      }

                    }
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: CustomTextField(
                  hintText: "Stock Symbol",
                  inputType: TextInputType.text,
                  maxLines: 1,
                  controller: buyTextController,
                  labelText: "Stock Name",
                ),
              ),
              Container(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
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
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: CustomTextField(
                          hintText: "Price",
                          inputType: TextInputType.text,
                          maxLines: 1,
                          controller: priceTextController,
                          labelText: "Price",
                          onChangedFunction: (value){
                            calculateAmount(quantityTextController.value.text,value );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text("Amount : ${amount!}"),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 3),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: CustomTextField(
                    hintText: "",
                    icon: Icons.date_range,
                    inputType: TextInputType.datetime,
                    maxLines: 1,
                    controller: dateTextController,
                    labelText: "Date",
                  ),
                ),
              ),
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
                padding: const EdgeInsets.all(15.0),
                child: CustomButton(text: "Add Trade", onPressed: () {}),
              )
            ],
          ),
        ),
      ),
    );
  }
}
