import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/shared/extensions/string_extensions.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/models/category_model.dart';
import 'package:ziyyer/shared/models/transaction_model.dart';
import 'package:ziyyer/shared/utils/amount_formatter.dart';
import 'package:ziyyer/theme.dart';

class TransactionStatsSection extends StatelessWidget {
  final BudgetModel budgetModel;
  final DateTime selectedMonth;

  const TransactionStatsSection({
    super.key,
    required this.budgetModel,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = _filteredTransactions;
    final totalSpent = filteredTransactions.fold<double>(0, (sum, t) => sum + t.amount);
    final txCount = filteredTransactions.length;

    final avgTransaction = txCount > 0 ? totalSpent / txCount : 0.0;
    final largestTransaction = txCount > 0
        ? filteredTransactions.reduce((a, b) => a.amount > b.amount ? a : b)
        : null;
    final mostActiveCategory = _findMostActiveCategory();

    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.transactions,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: AppLocalizations.of(context)!.avgTransaction,
                  value: AmountFormatter.formatCurrency(
                    avgTransaction,
                    currency: budgetModel.currency,
                  ),
                  icon: AppIcons.transaction,
                  iconColor: AppColors.info,
                  iconBgColor: AppColors.info.withAlpha(20),
                  context: context,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: _StatCard(
                  label: AppLocalizations.of(context)!.largestTransaction,
                  value: largestTransaction != null
                      ? AmountFormatter.formatCurrency(
                          largestTransaction.amount,
                          currency: budgetModel.currency,
                        )
                      : '-',
                  icon: AppIcons.trendingUp,
                  iconColor: AppColors.warning,
                  iconBgColor: AppColors.warning.withAlpha(20),
                  context: context,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: _StatCard(
                  label: AppLocalizations.of(context)!.mostActiveCategory,
                  value: mostActiveCategory?.name.capitalizeFirst() ?? '-',
                  icon: mostActiveCategory != null
                      ? AppIcons.categoryIconFor(mostActiveCategory.name)
                      : AppIcons.category,
                  iconColor: mostActiveCategory != null
                      ? AppColors.categoryColorFor(mostActiveCategory.name)
                      : AppColors.textHint(context),
                  iconBgColor: mostActiveCategory != null
                      ? AppColors.categoryColorFor(mostActiveCategory.name).withAlpha(20)
                      : AppColors.textHint(context).withAlpha(20),
                  context: context,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  CategoryModel? _findMostActiveCategory() {
    if (budgetModel.categories.isEmpty) return null;

    CategoryModel? top;
    var topCount = 0;

    for (final category in budgetModel.categories) {
      final count = category.transactions
          .where((t) => t.date.year == selectedMonth.year && t.date.month == selectedMonth.month)
          .length;
      if (count > topCount) {
        topCount = count;
        top = category;
      }
    }

    return top;
  }

  List<TransactionModel> get _filteredTransactions {
    return budgetModel.categories
        .expand((c) => c.transactions)
        .where((t) => t.date.year == selectedMonth.year && t.date.month == selectedMonth.month)
        .toList();
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final BuildContext context;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius - 4),
        border: Border.all(color: AppColors.divider(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 14),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppConstants.spacingExtraSmall),
          Text(
            value,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
