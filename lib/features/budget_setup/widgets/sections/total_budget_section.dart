import 'package:flutter/material.dart';
import 'package:ziyyer/shared/models/currency_model.dart';

class TotalBudgetSection extends StatelessWidget {
  final CurrencyModel currency;
  final TextEditingController amountController;

  const TotalBudgetSection({super.key, required this.currency, required this.amountController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 32,
          child: Text(
            currency.symbol,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
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
