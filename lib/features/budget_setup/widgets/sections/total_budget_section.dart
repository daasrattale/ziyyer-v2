import 'package:flutter/material.dart';
import 'package:ziyyer/shared/models/currency_model.dart';

class TotalBudgetSection extends StatelessWidget {
  final CurrencyModel currency;
  final TextEditingController amountController;
  const TotalBudgetSection({super.key, required this.currency, required this.amountController});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(currency.symbol, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        ),
        SizedBox(
          width: screenWidth * 0.8,
          child: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w800, letterSpacing: 1.2),
            decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
          ),
        ),
      ],
    );
  }
}
