import 'package:flutter/material.dart';
import 'package:stockfolio/widgets/custom_button.dart';
import 'package:stockfolio/widgets/custom_textfield.dart';

class Sell extends StatefulWidget {
  const Sell({super.key});

  @override
  State<Sell> createState() => _SellState();
}

class _SellState extends State<Sell> {
  final TextEditingController searchController = TextEditingController();
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
