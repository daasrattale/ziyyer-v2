import 'package:flutter/material.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/models/currency_model.dart';
import 'package:ziyyer/shared/utils/amount_formatter.dart';
import 'package:ziyyer/theme.dart';

class QuicksetSection extends StatelessWidget {
  final double amount;
  final CurrencyModel currency;
  final ValueChanged<double> onAmountSelected;

  const QuicksetSection({super.key, required this.amount, required this.currency, required this.onAmountSelected});

  @override
  Widget build(BuildContext context) {
    double defaultAmount = BudgetModel.init().definedAmount;
    final quickSetValues = [defaultAmount / 2, defaultAmount, defaultAmount + (defaultAmount * 0.6)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('QUICK SET', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(quickSetValues.length, (index) {
              final value = quickSetValues[index];
              final isSelected = value == amount;

              return Padding(
                padding: EdgeInsets.only(right: index == quickSetValues.length - 1 ? 0 : 12),
                child: GestureDetector(
                  onTap: () => onAmountSelected(value),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.transparent),
                    ),
                    child: Text(
                      '${currency.symbol} ${AmountFormatter.formatAmount(value)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
