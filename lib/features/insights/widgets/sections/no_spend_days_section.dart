import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/theme.dart';

class NoSpendDaysSection extends StatefulWidget {
  final BudgetModel budgetModel;
  final DateTime selectedMonth;

  const NoSpendDaysSection({
    super.key,
    required this.budgetModel,
    required this.selectedMonth,
  });

  @override
  State<NoSpendDaysSection> createState() => _NoSpendDaysSectionState();
}

class _NoSpendDaysSectionState extends State<NoSpendDaysSection>
    with TickerProviderStateMixin {
  late final AnimationController _dotAnimController;

  @override
  void initState() {
    super.initState();
    _dotAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _dotAnimController.forward();
  }

  @override
  void didUpdateWidget(covariant NoSpendDaysSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMonth != widget.selectedMonth) {
      _dotAnimController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _dotAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final isCurrentMonth = widget.selectedMonth.year == now.year && widget.selectedMonth.month == now.month;

    final totalDays = DateTime(widget.selectedMonth.year, widget.selectedMonth.month + 1, 0).day;
    final spendingDaysSet = _spendingDaysSet;
    final displayDays = isCurrentMonth ? now.day : totalDays;
    final noSpendDays = displayDays - spendingDaysSet.where((d) => d <= displayDays).length;

    final firstWeekday = DateTime(widget.selectedMonth.year, widget.selectedMonth.month, 1).weekday % 7;

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
                  AppLocalizations.of(context)!.noSpendDays,
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.income.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$noSpendDays ${AppLocalizations.of(context)!.daysTracked}',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.income,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            LayoutBuilder(
              builder: (context, constraints) {
                final cellSize = constraints.maxWidth / 7;
                final dotSize = (cellSize * 0.7).clamp(16.0, 32.0);

                return Column(
                  children: [
                    // Day labels
                    Row(
                      children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((l) {
                        return SizedBox(
                          width: cellSize,
                          child: Center(
                            child: Text(
                              l,
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.textHint(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    // Calendar grid
                    ...List.generate(((totalDays + firstWeekday) / 7).ceil(), (week) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: List.generate(7, (day) {
                            final dayIndex = week * 7 + day - firstWeekday + 1;
                            if (dayIndex < 1 || dayIndex > totalDays) {
                              return SizedBox(width: cellSize, height: cellSize);
                            }
                            final hasSpending = spendingDaysSet.contains(dayIndex);
                            final isFuture = isCurrentMonth && dayIndex > now.day;

                            final dotDelay = (dayIndex / totalDays).clamp(0.0, 1.0);
                            final dotStart = dotDelay * 0.6;
                            final dotEnd = (dotStart + 0.4).clamp(0.0, 1.0);

                            return SizedBox(
                              width: cellSize,
                              height: cellSize,
                              child: AnimatedBuilder(
                                animation: _dotAnimController,
                                builder: (context, _) {
                              final rawProgress = (_dotAnimController.value - dotStart) /
                                  (dotEnd - dotStart);
                              final dotProgress = Curves.easeOutCubic.transform(
                                rawProgress.clamp(0.0, 1.0),
                              );

                                  return Center(
                                    child: Transform.scale(
                                      scale: 0.5 + (dotProgress * 0.5),
                                      child: Container(
                                        width: dotSize,
                                        height: dotSize,
                                        decoration: BoxDecoration(
                                          color: isFuture
                                              ? Colors.transparent
                                              : hasSpending
                                                  ? AppColors.accentColor(context).withAlpha((dotProgress * 255).toInt())
                                                  : AppColors.income.withAlpha((dotProgress * 50).toInt()),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              '$dayIndex',
                                              style: TextStyle(
                                                color: isFuture
                                                    ? AppColors.textHint(context)
                                                    : hasSpending
                                                        ? AppColors.darkTextPrimary
                                                        : AppColors.income,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendDot(color: AppColors.income, label: AppLocalizations.of(context)!.noSpendDays),
                const SizedBox(width: AppConstants.spacingLarge),
                _LegendDot(color: AppColors.accentColor(context), label: AppLocalizations.of(context)!.transactions.toLowerCase()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Set<int> get _spendingDaysSet {
    final set = <int>{};
    for (final category in widget.budgetModel.categories) {
      for (final t in category.transactions) {
        if (t.date.year == widget.selectedMonth.year && t.date.month == widget.selectedMonth.month) {
          set.add(t.date.day);
        }
      }
    }
    return set;
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary(context),
          ),
        ),
      ],
    );
  }
}
