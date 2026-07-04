import 'package:flutter/material.dart';
import 'package:ziyyer/features/budget_setup/widgets/budget_setup_widget.dart';
import 'package:ziyyer/shared/services/budget_service.dart';
import 'package:ziyyer/shared/services/service_locator.dart';
import 'package:ziyyer/shared/ui/loader.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  /*
    Get the existing budget
    Check if exists
      - exists? => BudgetOverview
      - doesn't exists => BudgetSetup
   */

  @override
  Widget build(BuildContext context) {
    final BudgetService budgetService = ServiceLocator.budgetService;

    return Center(
      child: StreamBuilder(
        stream: budgetService.watchBudgetWithCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          }

          if (snapshot.hasData && snapshot.data != null) {
            return Loader();
          }

          return BudgetSetupWidget();
        },
      ),
    );
  }
}
