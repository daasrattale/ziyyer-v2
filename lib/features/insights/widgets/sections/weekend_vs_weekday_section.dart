import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/models/transaction_model.dart';
import 'package:ziyyer/theme.dart';

class WeekendVsWeekdaySection extends StatelessWidget {
  final BudgetModel budgetModel;
  final DateTime selectedMonth;

  const WeekendVsWeekdaySection({
    super.key,
    required this.budgetModel,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final transactions = _filteredTransactions;
    final weekendTotal = transactions
        .where((t) => t.date.weekday == 6 || t.date.weekday == 7)
        .fold<double>(0, (sum, t) => sum + t.amount);
    final weekdayTotal = transactions
        .where((t) => t.date.weekday >= 1 && t.date.weekday <= 5)
        .fold<double>(0, (sum, t) => sum + t.amount);

    final weekendDays = _weekendDaysInMonth;
    final weekdayDays = _weekdayDaysInMonth;
    final weekendAvg = weekendDays > 0 ? weekendTotal / weekendDays : 0.0;
    final weekdayAvg = weekdayDays > 0 ? weekdayTotal / weekdayDays : 0.0;

    final total = weekendTotal + weekdayTotal;
    final weekendPercentage = total > 0 ? weekendTotal / total : 0.0;
    final weekdayPercentage = total > 0 ? weekdayTotal / total : 0.0;

    final isWeekendHigher = weekendAvg > weekdayAvg;

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
              AppLocalizations.of(context)!.weekendVsWeekday,
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            Row(
              children: [
                Expanded(
                  child: _DayCard(
                    label: AppLocalizations.of(context)!.weekend,
                    total: weekendTotal,
                    avg: weekendAvg,
                    percentage: weekendPercentage,
                    days: weekendDays,
                    color: AppColors.warning,
                    icon: Icons.weekend,
                    isHigher: isWeekendHigher,
                    currency: budgetModel.currency.symbol,
                    context: context,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMedium),
                Expanded(
                  child: _DayCard(
                    label: AppLocalizations.of(context)!.weekday,
                    total: weekdayTotal,
                    avg: weekdayAvg,
                    percentage: weekdayPercentage,
                    days: weekdayDays,
                    color: AppColors.info,
                    icon: Icons.work,
                    isHigher: !isWeekendHigher,
                    currency: budgetModel.currency.symbol,
                    context: context,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.background(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isWeekendHigher
                      ? '${AppLocalizations.of(context)!.weekend} +${((weekendAvg / (weekdayAvg > 0 ? weekdayAvg : 1)) * 100 - 100).toStringAsFixed(0)}%'
                      : '${AppLocalizations.of(context)!.weekday} +${((weekdayAvg / (weekendAvg > 0 ? weekendAvg : 1)) * 100 - 100).toStringAsFixed(0)}%',
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TransactionModel> get _filteredTransactions {
    return budgetModel.categories
        .expand((c) => c.transactions)
        .where((t) => t.date.year == selectedMonth.year && t.date.month == selectedMonth.month)
        .toList();
  }

  int get _weekendDaysInMonth {
    final days = DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
    var count = 0;
    for (var d = 1; d <= days; d++) {
      final date = DateTime(selectedMonth.year, selectedMonth.month, d);
      if (date.weekday == 6 || date.weekday == 7) count++;
    }
    return count;
  }

  int get _weekdayDaysInMonth {
    final days = DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
    var count = 0;
    for (var d = 1; d <= days; d++) {
      final date = DateTime(selectedMonth.year, selectedMonth.month, d);
      if (date.weekday >= 1 && date.weekday <= 5) count++;
    }
    return count;
  }
}

class _DayCard extends StatelessWidget {
  final String label;
  final double total;
  final double avg;
  final double percentage;
  final int days;
  final Color color;
  final IconData icon;
  final bool isHigher;
  final String currency;
  final BuildContext context;

  const _DayCard({
    required this.label,
    required this.total,
    required this.avg,
    required this.percentage,
    required this.days,
    required this.color,
    required this.icon,
    required this.isHigher,
    required this.currency,
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
        border: isHigher
            ? Border.all(color: color.withAlpha(60), width: 1.5)
            : Border.all(color: AppColors.divider(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 14),
              ),
              Text(
                '${(percentage * 100).toStringAsFixed(0)}%',
                style: textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary(context),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: AppConstants.spacingExtraSmall),
          Text(
            '$currency${total.toInt()}',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppConstants.spacingExtraSmall),
          Text(
            '$currency${avg.toInt()} avg/day',
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
