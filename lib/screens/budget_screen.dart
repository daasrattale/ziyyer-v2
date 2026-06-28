import 'package:flutter/material.dart';
import 'package:ziyyer/model/budget_details.dart';
import 'package:ziyyer/services/service_locator.dart';
import 'package:ziyyer/widgets/budget_screen_header.dart';
import 'package:ziyyer/widgets/budget_setup.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: ServiceLocator.budgetService.watchBudget(),
            builder: (context, budgetSnapshot) {
              if (budgetSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (budgetSnapshot.hasData && budgetSnapshot.data == null) {
                return BudgetSetup();
              }

              final BudgetDetails budget = budgetSnapshot.data!;

              return Column(
                children: [
                  BudgetScreenHeader(
                    totalBudget: budget.definedAmount,
                    totalSpent: budget.realAmount,
                    allocated: budget.allocatedAmount,
                    unallocated: budget.unallocatedAmount,
                    currency: budget.currency,
                    onAddPressed: () {},
                    onEditPressed: () {},
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
