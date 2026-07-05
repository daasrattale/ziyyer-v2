import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ziyyer/features/budget_setup/widgets/budget_amount_currency_setup_widget.dart';
import 'package:ziyyer/features/budget_setup/widgets/budget_payments_setup_widget.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/widgets/custom_stepper.dart';

class BudgetSetupWidget extends StatefulWidget {
  const BudgetSetupWidget({super.key});

  @override
  State<BudgetSetupWidget> createState() => _BudgetSetupWidgetState();
}

class _BudgetSetupWidgetState extends State<BudgetSetupWidget> {
  int _currentIndex = 1;
  BudgetModel budgetModel = BudgetModel.init();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomStepper(
        initialActiveIndex: _currentIndex,
        goToNextStep: () {
          if (_currentIndex < 2) {
            setState(() {
              _currentIndex++;
            });
          }
        },
        goToDoneStep: () {
          // todo: define the done process to create the budget
        },
        goToPreviousStep: () {
          if (_currentIndex > 0) {
            setState(() {
              _currentIndex--;
            });
          }
        },
        steps: [
          CustomStepperStep(
            title: 'Budget Income',
            content: BudgetAmountCurrencySetupWidget(
              onAmountChanged: (amount) {
                setState(() {
                  budgetModel.definedAmount = amount;
                });
              },
              onCurrencyChanged: (currency) {
                budgetModel.currency = currency;
              },
            ),
          ),
          CustomStepperStep(
            title: 'Budget Payements',
            content: BudgetPaymentsSetupWidget(
              budgetModel: budgetModel,
              onPaymentsChanged: (payments) {
                setState(() {
                  log('payments: $payments');
                  budgetModel.payements = payments;
                });
              },
            ),
          ),
          CustomStepperStep(title: 'Spending categories', content: const Text("Order Details")),
        ],
      ),
    );
  }
}
