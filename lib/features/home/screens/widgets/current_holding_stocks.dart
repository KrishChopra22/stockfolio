import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/stock_transaction_model.dart';
import '../../../../utils/Colors.dart';

class CurrentHoldingStocks extends StatelessWidget {
  const CurrentHoldingStocks({
    super.key,
    required this.groupedUserHoldings,
    required this.timeFormat,
    required this.dateFormat,
  });

  final List<StockTransactionModel> groupedUserHoldings;
  final DateFormat timeFormat;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedUserHoldings.length,
      itemBuilder: (BuildContext context, int index) {
        double tradeAmount = groupedUserHoldings[index].price! *
            groupedUserHoldings[index].quantity!;
        // if(groupedUserHoldings[index].isBought==true) {
          // print(index);
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 5,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  groupedUserHoldings[index].stockSymbol!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      groupedUserHoldings[index].exchangeName!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.brown,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Qty : ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blue,
                          ),
                        ),
                        Text(
                          groupedUserHoldings[index].quantity!.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blue,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Prev Price : ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blue,
                          ),
                        ),
                        Text(
                          '₹ ${groupedUserHoldings[index].price!}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.yellow,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹ ${tradeAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${timeFormat.format(
                          groupedUserHoldings[index].transactionDate!)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.midBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${dateFormat.format(
                          groupedUserHoldings[index].transactionDate!)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.midBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // if (!context.mounted) {
                  //   return;
                  // }
                  // setState(() {
                  //   searchController.text =
                  //   filteredStocksList[index].stockSymbol!;
                  //   filteredStocksList.clear();
                  // }
                  // );
                },
              ),
            ),
          );
        // }else{
        //   return Container();
        // }
      },
    );
  }
}
