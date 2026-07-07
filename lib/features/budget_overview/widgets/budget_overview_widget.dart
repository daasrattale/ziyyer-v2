import 'package:flutter/material.dart';
import 'package:ziyyer/features/budget_overview/widgets/sections/home_header.dart';
import 'package:ziyyer/features/budget_overview/widgets/sections/spending_category_section.dart';
import 'package:ziyyer/features/budget_overview/widgets/sections/summary_card_row.dart';
import 'package:ziyyer/features/budget_overview/widgets/sections/total_balance_card.dart';
import 'package:ziyyer/shared/models/budget_model.dart';

class BudgetOverviewWidget extends StatelessWidget {
  final BudgetModel budgetModel;

  const BudgetOverviewWidget({super.key, required this.budgetModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HomeHeader(userName: "Super User", onNotificationTap: () {}),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BudgetSummary(budgetModel: budgetModel),
                  SummaryCardsRow(
                    incomeAmount: budgetModel.allocatedAmount,
                    transactionsAmount: budgetModel.realAmount,
                  ),
                  SpendingCategorySection(categories: budgetModel.categories),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
