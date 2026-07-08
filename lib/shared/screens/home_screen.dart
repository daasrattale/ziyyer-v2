import 'package:flutter/material.dart';
import 'package:ziyyer/features/budget_overview/widgets/budget_overview_widget.dart';
import 'package:ziyyer/features/budget_setup/widgets/budget_setup_widget.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/services/budget_service.dart';
import 'package:ziyyer/shared/services/service_locator.dart';
import 'package:ziyyer/shared/ui/loader.dart';
import 'package:ziyyer/shared/utils/toaster.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BudgetService budgetService = ServiceLocator.budgetService;
  bool didShowBudgetSetupToast = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: budgetService.watch(),
      builder: (context, budgetSnapshot) {
        if (budgetSnapshot.connectionState == ConnectionState.waiting) {
          return Loader();
        }

        BudgetModel budgetModel;

        if (!budgetSnapshot.hasData) {
          return const BudgetSetupWidget();
        }

        budgetModel = budgetSnapshot.data!;

        if (!budgetModel.isSetup) {
          if (!didShowBudgetSetupToast) {
            didShowBudgetSetupToast = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              Toaster.info("You didn't setup your budget, you'll be redirected to the budget setup wizard");
            });
          }
          return const BudgetSetupWidget();
        }

        return BudgetOverviewWidget(budgetModel: budgetModel);
      },
    );
  }
}
