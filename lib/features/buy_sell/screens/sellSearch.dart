import 'package:fk_toggle/fk_toggle.dart';
import 'package:flutter/material.dart';
import 'package:stockfolio/widgets/custom_button.dart';
import 'package:stockfolio/widgets/custom_textfield.dart';

import 'buy.dart';

class Sell extends StatefulWidget {
  const Sell({Key? key}) : super(key: key);

  @override
  State<Sell> createState() => _SellState();
}

class _SellState extends State<Sell> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("New Trade"),
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
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: CustomTextField(
                hintText: "Stock Symbol",
                icon: Icons.search,
                inputType: TextInputType.text,
                maxLines: 1,
                controller: searchController,
                labelText: 'Search',
              ),
            ),
            Text("Current Holding"),
            Column(
              children: [
                Card(
                  color: Colors.blueGrey,
                  
                ),
                CustomButton(text: "Add Trade", onPressed: (){})
              ],
            )
          ],
        ),
      ),
    );
  }
}
