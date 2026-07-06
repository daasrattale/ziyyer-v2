import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziyyer/features/budget_setup/widgets/budget_amount_currency_setup_step.dart';
import 'package:ziyyer/features/budget_setup/widgets/budget_categories_setup_step.dart';
import 'package:ziyyer/features/budget_setup/widgets/budget_payments_setup_step.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/services/budget_service.dart';
import 'package:ziyyer/shared/services/service_locator.dart';
import 'package:ziyyer/shared/ui/loader.dart';
import 'package:ziyyer/shared/utils/toaster.dart';
import 'package:ziyyer/widgets/custom_stepper.dart';

class BudgetSetupWidget extends StatefulWidget {
  const BudgetSetupWidget({super.key});

  @override
  State<BudgetSetupWidget> createState() => _BudgetSetupWidgetState();
}

class _BudgetSetupWidgetState extends State<BudgetSetupWidget> {
  int _currentIndex = 0;

  BudgetService budgetService = ServiceLocator.budgetService;

  void syncBudget(BudgetModel budgetModel) {
    budgetService.persist(budgetModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<BudgetModel?>(
        stream: budgetService.watch(),
        builder: (context, budgetSnapshot) {
          if (budgetSnapshot.connectionState == ConnectionState.waiting && _currentIndex == 0) {
            return Loader();
          }

          BudgetModel budgetModel = budgetSnapshot.data!;

          log("budget: $budgetModel");

          return CustomStepper(
            initialActiveIndex: _currentIndex,
            goToNextStep: () {
              if (_currentIndex > 2) return;
              // Amount Step
              if (_currentIndex == 0 && budgetModel.definedAmount <= 0) {
                Toaster.error('Budget amount must be greater than 0');
                return;
              }
              // Payments Step
              if (_currentIndex == 1 && budgetModel.definedAmount - budgetModel.allocatedPayementsAmount < 0) {
                Toaster.error('Budget unallocated must be greater than 0');
                return;
              }
              // Categories Step
              if (_currentIndex == 2 && budgetModel.unallocatedAmount < 0) {
                Toaster.error('Budget unallocated must be greater than 0');
                return;
              }
              budgetService.persist(budgetModel);

              setState(() {
                _currentIndex++;
              });
            },
            goToDoneStep: () {
              budgetService.persist(budgetModel);
              _currentIndex = 0;
              context.go("/");
            },
            goToPreviousStep: () {
              if (_currentIndex > 0) {
                budgetService.persist(budgetModel);
                setState(() {
                  _currentIndex--;
                });
              }
            },
            steps: [
              CustomStepperStep(
                title: 'Budget Income',
                content: BudgetAmountCurrencySetupStep(
                  budgetModel: budgetModel,
                  onAmountChanged: (amount) {
                    if (!mounted) return;
                    budgetModel.definedAmount = amount;
                  },
                  onCurrencyChanged: (currency) {
                    budgetModel.currency = currency;
                  },
                ),
              ),
              CustomStepperStep(
                title: 'Budget Payements',
                content: BudgetPaymentsSetupStep(
                  budgetModel: budgetModel,
                  onPaymentsChanged: (payments) {
                    if (!mounted) return;
                    budgetModel.payments = payments;
                  },
                ),
              ),
              CustomStepperStep(
                title: 'Spending categories',
                content: BudgetCategoriesSetupStep(
                  budgetModel: budgetModel,
                  onCategoriesChanged: (categories) {
                    if (!mounted) return;
                    budgetModel.categories = categories;
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
