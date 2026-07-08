import 'package:flutter/material.dart';
import 'package:ziyyer/features/budget_setup/widgets/sections/currency_selector_section.dart';
import 'package:ziyyer/features/budget_setup/widgets/sections/quickset_section.dart';
import 'package:ziyyer/features/budget_setup/widgets/sections/title_section.dart';
import 'package:ziyyer/features/budget_setup/widgets/sections/total_budget_section.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/models/currency_model.dart';

class BudgetAmountCurrencySetupStep extends StatefulWidget {
  final BudgetModel budgetModel;
  final Function(double amount) onAmountChanged;
  final Function(CurrencyModel currency) onCurrencyChanged;

  const BudgetAmountCurrencySetupStep({
    super.key,
    required this.onAmountChanged,
    required this.onCurrencyChanged,
    required this.budgetModel,
  });

  @override
  State<BudgetAmountCurrencySetupStep> createState() => _BudgetAmountCurrencySetupStepState();
}

class _BudgetAmountCurrencySetupStepState extends State<BudgetAmountCurrencySetupStep> {
  late CurrencyModel currency;
  late double amount;
  late final TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    amount = widget.budgetModel.definedAmount;
    currency = widget.budgetModel.currency;
    amountController = TextEditingController(text: widget.budgetModel.definedAmount.toString());

    amountController.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    setState(() {
      double newAmountValue = double.tryParse(amountController.text) ?? 0.0;
      amount = newAmountValue;
      widget.onAmountChanged.call(newAmountValue);
    });
  }

  @override
  void dispose() {
    amountController.removeListener(_onAmountChanged);
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TitleSection(),
            const SizedBox(height: 24),
            CurrencySelectorSection(
              currency: currency,
              onCurrencyUpdated: (currency) {
                setState(() {
                  this.currency = currency;
                  widget.onCurrencyChanged.call(currency);
                });
              },
            ),
            const SizedBox(height: 24),
            TotalBudgetSection(currency: currency, amountController: amountController),
            const SizedBox(height: 24),
            QuicksetSection(
              amount: amount,
              currency: currency,
              onAmountSelected: (value) {
                amountController.text = value.toString();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
