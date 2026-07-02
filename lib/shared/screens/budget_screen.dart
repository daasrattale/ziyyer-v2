import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/shared/screens/demo_screen.dart';
import 'package:ziyyer/shared/services/budget_service.dart';
import 'package:ziyyer/shared/services/service_locator.dart';

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

    return DemoScreen(title: 'Budget Screen', iconData: AppIcons.budget);
  }
}
