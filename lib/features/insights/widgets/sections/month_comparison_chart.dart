import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/utils/amount_formatter.dart';
import 'package:ziyyer/theme.dart';

class MonthComparisonChart extends StatelessWidget {
  final BudgetModel budgetModel;
  final DateTime selectedMonth;

  const MonthComparisonChart({
    super.key,
    required this.budgetModel,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final thisMonthTotal = _totalForMonth(selectedMonth);
    final lastMonthTotal = _totalForMonth(_previousMonth);
    final maxVal = [thisMonthTotal, lastMonthTotal, budgetModel.definedAmount]
        .reduce((a, b) => a > b ? a : b);

    final difference = thisMonthTotal - lastMonthTotal;
    final diffLabel = difference >= 0
        ? '+${AmountFormatter.formatAmount(difference.abs())}'
        : '-${AmountFormatter.formatAmount(difference.abs())}';

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
                  AppLocalizations.of(context)!.monthComparison,
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  diffLabel,
                  style: textTheme.labelMedium?.copyWith(
                    color: difference >= 0 ? AppColors.expense : AppColors.income,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxVal > 0 ? maxVal * 1.3 : 100,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final label = group.x == 0
                            ? AppLocalizations.of(context)!.lastMonth
                            : AppLocalizations.of(context)!.thisMonth;
                        return BarTooltipItem(
                          '$label\n${AmountFormatter.formatCurrency(rod.toY, currency: budgetModel.currency)}',
                          textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ) ?? const TextStyle(),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final label = value == 0
                              ? AppLocalizations.of(context)!.lastMonth
                              : AppLocalizations.of(context)!.thisMonth;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              label,
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.textSecondary(context),
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: lastMonthTotal,
                          color: AppColors.textHint(context),
                          width: 40,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: thisMonthTotal,
                          color: AppColors.accentColor(context),
                          width: 40,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _LegendItem(
                  color: AppColors.textHint(context),
                  label: AppLocalizations.of(context)!.lastMonth,
                  amount: lastMonthTotal,
                  currency: budgetModel.currency.symbol,
                  context: context,
                ),
                _LegendItem(
                  color: AppColors.accentColor(context),
                  label: AppLocalizations.of(context)!.thisMonth,
                  amount: thisMonthTotal,
                  currency: budgetModel.currency.symbol,
                  context: context,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _totalForMonth(DateTime month) {
    return budgetModel.categories
        .expand((c) => c.transactions)
        .where((t) => t.date.year == month.year && t.date.month == month.month)
        .fold<double>(0, (sum, t) => sum + t.amount);
  }

  DateTime get _previousMonth => DateTime(selectedMonth.year, selectedMonth.month - 1);
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final double amount;
  final String currency;
  final BuildContext context;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.amount,
    required this.currency,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary(context),
              ),
            ),
            Text(
              '$currency${AmountFormatter.formatAmount(amount)}',
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }
}
