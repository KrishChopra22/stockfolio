import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stockfolio/models/stock_transaction_model.dart';
import 'package:stockfolio/utils/Colors.dart';

class PastHoldingStocks extends StatelessWidget {
  const PastHoldingStocks({
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
        final double tradeAmount = groupedUserHoldings[index].price! *
            groupedUserHoldings[index].quantity!;

        if (groupedUserHoldings[index].isBought == false) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 5,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.grey,
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
                        color: AppColors.darkGrey,
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Qty : ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          groupedUserHoldings[index].quantity!.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Avg Price : ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: AppColors.black,
                          ),
                        ),
                        Text(
                          '₹ ${groupedUserHoldings[index].price!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
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
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      timeFormat.format(
                        groupedUserHoldings[index].transactionDate!,
                      ),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      dateFormat.format(
                        groupedUserHoldings[index].transactionDate!,
                      ),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                onTap: () {},
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
