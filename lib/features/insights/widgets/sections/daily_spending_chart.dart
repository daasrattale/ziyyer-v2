import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/utils/amount_formatter.dart';
import 'package:ziyyer/theme.dart';

class DailySpendingChart extends StatelessWidget {
  final BudgetModel budgetModel;
  final DateTime selectedMonth;

  const DailySpendingChart({
    super.key,
    required this.budgetModel,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dailySpending = _dailySpending;
    final maxSpending = dailySpending.values.fold<double>(0, (max, v) => v > max ? v : max);
    final hasData = dailySpending.values.any((v) => v > 0);

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
                  AppLocalizations.of(context)!.dailySpending,
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                if (hasData)
                  Text(
                    AmountFormatter.formatCurrency(
                      maxSpending,
                      currency: budgetModel.currency,
                    ),
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary(context),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            if (!hasData)
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
              SizedBox(
                height: 160,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxSpending > 0 ? maxSpending * 1.2 : 100,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            AmountFormatter.formatCurrency(
                              rod.toY,
                              currency: budgetModel.currency,
                            ),
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
                          reservedSize: 20,
                          getTitlesWidget: (value, meta) {
                            final day = value.toInt();
                            if (day % 5 == 1 || day == 1) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '$day',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: AppColors.textSecondary(context),
                                    fontSize: 9,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(_daysInMonth, (index) {
                      final day = index + 1;
                      final amount = dailySpending[day] ?? 0.0;

                      return BarChartGroupData(
                        x: day,
                        barRods: [
                          BarChartRodData(
                            toY: amount,
                            color: amount > 0
                                ? AppColors.accentColor(context)
                                : AppColors.divider(context).withAlpha(60),
                            width: _daysInMonth > 28 ? 6 : 8,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(3),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Map<int, double> get _dailySpending {
    final map = <int, double>{};
    final days = _daysInMonth;

    for (var day = 1; day <= days; day++) {
      map[day] = 0.0;
    }

    for (final category in budgetModel.categories) {
      for (final transaction in category.transactions) {
        if (transaction.date.year == selectedMonth.year &&
            transaction.date.month == selectedMonth.month) {
          final day = transaction.date.day;
          map[day] = (map[day] ?? 0) + transaction.amount;
        }
      }
    }

    return map;
  }

  int get _daysInMonth {
    return DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
  }
}
