import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/features/budget_setup/controllers/budget_setup_controller.dart';
import 'package:ziyyer/features/budget_setup/widgets/fragments/currency_selector_section.dart';
import 'package:ziyyer/features/budget_setup/widgets/fragments/quickset_section.dart';
import 'package:ziyyer/features/budget_setup/widgets/fragments/steps_section.dart';
import 'package:ziyyer/features/budget_setup/widgets/fragments/title_section.dart';
import 'package:ziyyer/features/budget_setup/widgets/fragments/total_budget_section.dart';
import 'package:ziyyer/shared/models/currency_model.dart';

class BudgetSetupWidget extends StatefulWidget {
  const BudgetSetupWidget({super.key});

  @override
  State<BudgetSetupWidget> createState() => _BudgetSetupWidgetState();
}

class _BudgetSetupWidgetState extends State<BudgetSetupWidget> {
  int stepIndex = 0;
  final int totalSteps = 5;

  late CurrencyModel currency;
  late double amount;
  late final TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    amount = BudgetSetupController.instance.defaultBudgetAmount;
    currency = AppConstants.supportedCurrencies.first;
    amountController = TextEditingController(text: amount.toString());

    amountController.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    setState(() {
      amount = double.tryParse(amountController.text) ?? 0.0;
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: const Text(
              'Budget & Currency',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 32),
        StepsSection(),
        const SizedBox(height: 32),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TitleSection(),
                  const SizedBox(height: 24),
                  CurrencySelectorSection(
                    currency: currency,
                    onCurrencyUpdated: (currency) {
                      setState(() {
                        this.currency = currency;
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
          ),
        ),
      ],
    );
  }
}
