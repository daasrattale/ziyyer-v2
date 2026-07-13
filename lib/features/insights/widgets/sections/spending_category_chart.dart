import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/shared/extensions/string_extensions.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/models/category_model.dart';
import 'package:ziyyer/shared/utils/amount_formatter.dart';
import 'package:ziyyer/theme.dart';

class SpendingCategoryChart extends StatelessWidget {
  final BudgetModel budgetModel;
  final DateTime selectedMonth;

  const SpendingCategoryChart({
    super.key,
    required this.budgetModel,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final categoriesWithSpending = _categoriesWithSpending;
    final totalSpent = categoriesWithSpending.fold<double>(0, (sum, e) => sum + e.$2);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  AppLocalizations.of(context)!.spendingByCategory,
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            if (categoriesWithSpending.isEmpty)
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
              Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                              sections: categoriesWithSpending.map((entry) {
                                final category = entry.$1;
                                final spent = entry.$2;
                                final percentage = totalSpent > 0 ? (spent / totalSpent * 100) : 0.0;
                                final color = AppColors.categoryColorFor(category.name);

                                return PieChartSectionData(
                                  value: spent,
                                  color: color,
                                  radius: 50,
                                  title: '${percentage.toStringAsFixed(0)}%',
                                  titleStyle: textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMedium),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: categoriesWithSpending.take(5).map((entry) {
                              final category = entry.$1;
                              final spent = entry.$2;
                              final color = AppColors.categoryColorFor(category.name);
                              final percentage = totalSpent > 0 ? (spent / totalSpent * 100) : 0.0;

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            category.name.capitalizeFirst(),
                                            style: textTheme.labelMedium?.copyWith(
                                              color: AppColors.textPrimary(context),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${percentage.toStringAsFixed(0)}% · ${AmountFormatter.formatAmount(spent)}${budgetModel.currency.symbol}',
                                            style: textTheme.labelSmall?.copyWith(
                                              color: AppColors.textSecondary(context),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),
                  ...categoriesWithSpending.take(5).map((entry) {
                    final category = entry.$1;
                    final spent = entry.$2;
                    final percentage = totalSpent > 0 ? (spent / totalSpent) : 0.0;
                    final color = AppColors.categoryColorFor(category.name);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppConstants.spacingSmall),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withAlpha(30),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              AppIcons.categoryIconFor(category.name),
                              color: color,
                              size: 12,
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingMedium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      category.name.capitalizeFirst(),
                                      style: textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      AmountFormatter.formatCurrency(
                                        spent,
                                        currency: budgetModel.currency,
                                      ),
                                      style: textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  height: 4,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.divider(context).withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: percentage.clamp(0.0, 1.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(2.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
          ],
        ),
      ),
    );
  }

  List<(CategoryModel, double)> get _categoriesWithSpending {
    final result = <(CategoryModel, double)>[];

    for (final category in budgetModel.categories) {
      final spent = category.transactions
          .where((t) => t.date.year == selectedMonth.year && t.date.month == selectedMonth.month)
          .fold<double>(0, (sum, t) => sum + t.amount);

      if (spent > 0) {
        result.add((category, spent));
      }
    }

    result.sort((a, b) => b.$2.compareTo(a.$2));
    return result;
  }
}
