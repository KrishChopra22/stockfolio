import 'package:flutter/material.dart';
import 'package:stockfolio/widgets/custom_button.dart';
import 'package:stockfolio/widgets/custom_textfield.dart';

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
