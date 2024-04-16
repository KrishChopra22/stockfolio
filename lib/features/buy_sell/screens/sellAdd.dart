import 'package:fk_toggle/fk_toggle.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import 'buy.dart';

class SellNext extends StatefulWidget {
  const SellNext({Key? key}) : super(key: key);

  @override
  State<SellNext> createState() => _SellNextState();
}

class _SellNextState extends State<SellNext> {
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
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Text("New Trade")),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FkToggle(
                    selectedColor: Colors.black,
                    height: MediaQuery.of(context).size.height / 20,
                    width: 210,
                    labels: const <String>['Buy', 'Sell'],
                    onSelected: (value,toggle){
                      if(value==0){
                        print("Buy selected");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Buy())
                        );
                      }
                    }
                ),
              ),
              Text("Owned"),
              Card(),
              Container(
                constraints:
                BoxConstraints(maxWidth: MediaQuery
                    .of(context)
                    .size
                    .width),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: CustomTextField(
                          hintText: "Quantity",
                          icon: Icons.add,
                          inputType: TextInputType.text,
                          maxLines: 1,
                          controller: quantityTextController,
                          labelText: 'Stock Name',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: CustomTextField(
                          hintText: "Price",
                          icon: Icons.add,
                          inputType: TextInputType.text,
                          maxLines: 1,
                          controller: priceTextController,
                          labelText: "Stock Name",
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
                constraints:
                BoxConstraints(maxWidth: MediaQuery
                    .of(context)
                    .size
                    .width / 3),

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
