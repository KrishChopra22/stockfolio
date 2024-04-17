import 'package:flutter/material.dart';
import 'package:stockfolio/features/stocks/screens/sell2.dart';
import 'package:stockfolio/models/stock_transaction_model.dart';
import 'package:stockfolio/widgets/custom_button.dart';

class Sell extends StatefulWidget {
  const Sell({super.key, required this.userStocksList});

  final List<StockTransactionModel> userStocksList;

  @override
  State<Sell> createState() => _SellState();
}

class _SellState extends State<Sell> {
  final TextEditingController searchController = TextEditingController();
  String searchText = '';
  List<StockTransactionModel> filteredStocksList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  onTapOutside: (PointerDownEvent event) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  showCursor: true,
                  onChanged: (value) {
                    searchText = value;
                    if (searchText.isEmpty) {
                      filteredStocksList.clear();
                    }
                    setState(() {
                      filteredStocksList = widget.userStocksList
                          .where(
                            (stock) => stock.stockSymbol!
                                .toLowerCase()
                                .contains(searchText.toLowerCase()),
                          )
                          .toList();
                    });
                  },
                  cursorColor: Colors.deepPurple.shade800,
                  controller: searchController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.deepPurple.shade800,
                      ),
                      child: const Icon(
                        Icons.search_rounded,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    suffixIcon: Icon(
                      Icons.expand_circle_down_rounded,
                      size: 20,
                      color: Colors.deepPurple.shade800,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.deepPurple.shade800,
                      ),
                    ),
                    hintText: 'Enter Stock Symbol',
                    labelText: 'Stock Symbol',
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.deepPurple.shade800,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    fillColor: Colors.deepPurple.shade50,
                    filled: true,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredStocksList.length > 6
                    ? 6
                    : filteredStocksList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 5,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          filteredStocksList[index].stockSymbol!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          filteredStocksList[index].exchangeName!,
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        trailing: Text(
                          filteredStocksList[index].price!.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          if (!context.mounted) {
                            return;
                          }
                          setState(() {
                            searchController.text =
                                filteredStocksList[index].stockSymbol!;
                            filteredStocksList.clear();
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              // const Text('Current Holding'),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: CustomButton(
                  text: 'Add Trade',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SellNext(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
