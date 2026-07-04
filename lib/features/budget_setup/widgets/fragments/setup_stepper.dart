import 'package:flutter/material.dart';
import 'package:ziyyer/features/budget_setup/widgets/budget_amount_currency_setup_widget.dart';
import 'package:ziyyer/widgets/custom_stepper.dart';

class SetupStepper extends StatefulWidget {
  const SetupStepper({super.key});
  @override
  State<SetupStepper> createState() => _SetupStepperState();
}

class _SetupStepperState extends State<SetupStepper> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomStepper(
            initialActiveIndex: _currentIndex,
            goToNextStep: () {
              if (_currentIndex < 2) {
                setState(() {
                  _currentIndex++;
                });
              }
            },
            goToPreviousStep: () {
              if (_currentIndex > 0) {
                setState(() {
                  _currentIndex--;
                });
              }
            },
            steps: [
              CustomStepperStep(title: 'Budget', content: BudgetAmountCurrencySetupWidget()),
              CustomStepperStep(title: 'Budget', content: const Text("Location Details")),
              CustomStepperStep(title: 'Budget', content: const Text("Order Details")),
            ],
          ),
        ],
      ),
    );
  }
}
