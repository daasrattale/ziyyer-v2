import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/shared/extensions/string_extensions.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/models/transaction_model.dart';
import 'package:ziyyer/shared/utils/amount_formatter.dart';
import 'package:ziyyer/theme.dart';

class BiggestExpenseSection extends StatelessWidget {
  final BudgetModel budgetModel;
  final DateTime selectedMonth;

  const BiggestExpenseSection({
    super.key,
    required this.budgetModel,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final biggest = _biggestExpense;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenMargin),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          border: Border.all(color: AppColors.divider(context), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.biggestExpense,
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            if (biggest == null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingLarge),
                  child: Text(
                    AppLocalizations.of(context)!.noDataForMonth,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                decoration: BoxDecoration(
                  color: AppColors.background(context),
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius - 4),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _categoryColor.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        AppIcons.categoryIconFor(_categoryName),
                        color: _categoryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _categoryName.capitalizeFirst(),
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            biggest.description ?? AppLocalizations.of(context)!.noDescription,
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          AmountFormatter.formatCurrency(
                            biggest.amount,
                            currency: budgetModel.currency,
                          ),
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.expense,
                          ),
                        ),
                        Text(
                          '$_dayOfMonth $_monthName',
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  TransactionModel? get _biggestExpense {
    final transactions = _filteredTransactions;
    if (transactions.isEmpty) return null;
    return transactions.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  String get _categoryName {
    final biggest = _biggestExpense;
    if (biggest == null) return '';
    for (final category in budgetModel.categories) {
      if (category.transactions.any((t) => t.id == biggest.id)) {
        return category.name;
      }
    }
    return '';
  }

  Color get _categoryColor {
    return AppColors.categoryColorFor(_categoryName);
  }

  String get _dayOfMonth {
    final biggest = _biggestExpense;
    if (biggest == null) return '';
    return biggest.date.day.toString();
  }

  String get _monthName {
    final biggest = _biggestExpense;
    if (biggest == null) return '';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[biggest.date.month - 1];
  }

  List<TransactionModel> get _filteredTransactions {
    return budgetModel.categories
        .expand((c) => c.transactions)
        .where((t) => t.date.year == selectedMonth.year && t.date.month == selectedMonth.month)
        .toList();
  }
}
