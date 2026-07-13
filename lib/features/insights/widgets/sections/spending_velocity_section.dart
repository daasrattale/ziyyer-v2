import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/models/transaction_model.dart';
import 'package:ziyyer/shared/utils/amount_formatter.dart';
import 'package:ziyyer/theme.dart';

class SpendingVelocitySection extends StatefulWidget {
  final BudgetModel budgetModel;
  final DateTime selectedMonth;

  const SpendingVelocitySection({
    super.key,
    required this.budgetModel,
    required this.selectedMonth,
  });

  @override
  State<SpendingVelocitySection> createState() => _SpendingVelocitySectionState();
}

class _SpendingVelocitySectionState extends State<SpendingVelocitySection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _counterController;
  late final Animation<double> _counterAnimation;

  @override
  void initState() {
    super.initState();
    _counterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _counterAnimation = CurvedAnimation(
      parent: _counterController,
      curve: Curves.easeOutCubic,
    );
    _counterController.forward();
  }

  @override
  void didUpdateWidget(covariant SpendingVelocitySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedMonth != widget.selectedMonth) {
      _counterController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _counterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final isCurrentMonth = widget.selectedMonth.year == now.year && widget.selectedMonth.month == now.month;

    final currentTransactions = _transactionsForMonth(widget.selectedMonth);
    final lastMonthTransactions = _transactionsForMonth(_previousMonth);

    final currentTotal = currentTransactions.fold<double>(0, (sum, t) => sum + t.amount);
    final lastMonthTotal = lastMonthTransactions.fold<double>(0, (sum, t) => sum + t.amount);

    final currentDays = isCurrentMonth ? now.day : _daysInMonth;
    final dailyAvg = currentDays > 0 ? currentTotal / currentDays : 0.0;
    final totalDaysInMonth = DateTime(widget.selectedMonth.year, widget.selectedMonth.month + 1, 0).day;
    final projectedTotal = dailyAvg * totalDaysInMonth;
    final difference = currentTotal - lastMonthTotal;

    final paceStatus = _paceStatus(projectedTotal, widget.budgetModel.definedAmount);
    final paceIcon = _paceIcon(paceStatus);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenMargin),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accentColor(context),
              AppColors.accentColor(context).withValues(alpha: 0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
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
                  AppLocalizations.of(context)!.spendingVelocity.toUpperCase(),
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.darkTextPrimary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(paceIcon, color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        paceStatus == 'over'
                            ? AppLocalizations.of(context)!.overPace
                            : paceStatus == 'under'
                                ? AppLocalizations.of(context)!.underPace
                                : AppLocalizations.of(context)!.onTrack,
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            AnimatedBuilder(
              animation: _counterAnimation,
              builder: (context, _) {
                return Row(
                  children: [
                    Expanded(
                      child: _VelocityStat(
                        label: AppLocalizations.of(context)!.dailyAverage,
                        amount: dailyAvg * _counterAnimation.value,
                        currency: widget.budgetModel.currency.symbol,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    Expanded(
                      child: _VelocityStat(
                        label: AppLocalizations.of(context)!.projectedTotal,
                        amount: projectedTotal * _counterAnimation.value,
                        currency: widget.budgetModel.currency.symbol,
                        isHighlight: true,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.white.withValues(alpha: 0.14), height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  difference >= 0 ? AppIcons.trendingUp : AppIcons.trendingDown,
                  color: difference >= 0
                      ? Colors.white.withValues(alpha: 0.8)
                      : AppColors.income,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  difference >= 0
                      ? '+${AmountFormatter.formatAmount(difference.abs())} ${AppLocalizations.of(context)!.moreThanLastMonth}'
                      : '-${AmountFormatter.formatAmount(difference.abs())} ${AppLocalizations.of(context)!.lessThanLastMonth}',
                  style: textTheme.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _paceStatus(double projected, double budget) {
    if (budget <= 0) return 'on';
    final ratio = projected / budget;
    if (ratio > 1.05) return 'over';
    if (ratio < 0.95) return 'under';
    return 'on';
  }

  IconData _paceIcon(String status) {
    if (status == 'over') return AppIcons.trendingUp;
    if (status == 'under') return AppIcons.trendingDown;
    return AppIcons.check;
  }

  DateTime get _previousMonth => DateTime(widget.selectedMonth.year, widget.selectedMonth.month - 1);
  int get _daysInMonth => DateTime(widget.selectedMonth.year, widget.selectedMonth.month + 1, 0).day;

  List<TransactionModel> _transactionsForMonth(DateTime month) {
    return widget.budgetModel.categories
        .expand((c) => c.transactions)
        .where((t) => t.date.year == month.year && t.date.month == month.month)
        .toList();
  }
}

class _VelocityStat extends StatelessWidget {
  final String label;
  final double amount;
  final String currency;
  final bool isHighlight;

  const _VelocityStat({
    required this.label,
    required this.amount,
    required this.currency,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.6),
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: AppConstants.spacingExtraSmall),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                currency,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.darkTextPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                AmountFormatter.formatAmount(amount),
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.darkTextPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
