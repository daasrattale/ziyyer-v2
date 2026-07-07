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
  final BudgetService budgetService = ServiceLocator.budgetService;

  late final Stream<BudgetModel?> _budgetStream;

  BudgetModel _budgetModel = BudgetModel.init();
  bool _initialLoading = true;

  @override
  void initState() {
    super.initState();
    _budgetStream = budgetService.watch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<BudgetModel?>(
        stream: _budgetStream,
        initialData: _budgetModel,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data != null) {
            _budgetModel = data;
          }

          final hasData = snapshot.hasData;
          if (_initialLoading && hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _initialLoading = false;
                });
              }
            });
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: _initialLoading
                ? const Center(key: ValueKey('loader'), child: Loader())
                : KeyedSubtree(
                    key: const ValueKey('stepper'),
                    child: CustomStepper(
                      activeIndex: _currentIndex,
                      goToNextStep: () {
                        if (_currentIndex > 2) return;

                        if (_currentIndex == 0 && _budgetModel.definedAmount <= 0) {
                          Toaster.error('Budget amount must be greater than 0');
                          return;
                        }

                        if (_currentIndex == 1 &&
                            _budgetModel.definedAmount - _budgetModel.allocatedPayementsAmount < 0) {
                          Toaster.error('Budget unallocated must be greater than 0');
                          return;
                        }

                        if (_currentIndex == 2 && _budgetModel.unallocatedAmount < 0) {
                          Toaster.error('Budget unallocated must be greater than 0');
                          return;
                        }

                        budgetService.persist(_budgetModel);

                        setState(() {
                          _currentIndex++;
                        });
                      },
                      goToDoneStep: () {
                        budgetService.persist(_budgetModel);
                        _currentIndex = 0;
                        context.go("/");
                      },
                      goToPreviousStep: () {
                        if (_currentIndex > 0) {
                          budgetService.persist(_budgetModel);
                          setState(() {
                            _currentIndex--;
                          });
                        } else {
                          context.go("/");
                        }
                      },
                      steps: [
                        CustomStepperStep(
                          title: 'Budget Income',
                          content: BudgetAmountCurrencySetupStep(
                            budgetModel: _budgetModel,
                            onAmountChanged: (amount) {
                              _budgetModel.definedAmount = amount;
                            },
                            onCurrencyChanged: (currency) {
                              _budgetModel.currency = currency;
                            },
                          ),
                        ),
                        CustomStepperStep(
                          title: 'Budget Payements',
                          content: BudgetPaymentsSetupStep(
                            budgetModel: _budgetModel,
                            onPaymentsChanged: (payments) {
                              _budgetModel.payments = payments;
                            },
                          ),
                        ),
                        CustomStepperStep(
                          title: 'Spending categories',
                          content: BudgetCategoriesSetupStep(
                            budgetModel: _budgetModel,
                            onCategoriesChanged: (categories) {
                              _budgetModel.categories = categories;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
