import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/features/insights/widgets/sections/biggest_expense_section.dart';
import 'package:ziyyer/features/insights/widgets/sections/budget_health_section.dart';
import 'package:ziyyer/features/insights/widgets/sections/daily_spending_chart.dart';
import 'package:ziyyer/features/insights/widgets/sections/insights_header.dart';
import 'package:ziyyer/features/insights/widgets/sections/month_comparison_chart.dart';
import 'package:ziyyer/features/insights/widgets/sections/no_spend_days_section.dart';
import 'package:ziyyer/features/insights/widgets/sections/payment_method_section.dart';
import 'package:ziyyer/features/insights/widgets/sections/spending_category_chart.dart';
import 'package:ziyyer/features/insights/widgets/sections/spending_velocity_section.dart';
import 'package:ziyyer/features/insights/widgets/sections/transaction_stats_section.dart';
import 'package:ziyyer/features/insights/widgets/sections/weekend_vs_weekday_section.dart';
import 'package:ziyyer/shared/models/budget_model.dart';

class InsightsWidget extends StatefulWidget {
  final BudgetModel budgetModel;
  final ValueChanged<DateTime>? onMonthChanged;

  const InsightsWidget({super.key, required this.budgetModel, this.onMonthChanged});

  @override
  State<InsightsWidget> createState() => _InsightsWidgetState();
}

class _InsightsWidgetState extends State<InsightsWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;
  late DateTime _selectedMonth;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _staggerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _staggerController, curve: Curves.easeOut);
    _staggerController.forward();
  }

  @override
  void didUpdateWidget(covariant InsightsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.budgetModel != widget.budgetModel) {
      _staggerController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentMonthSpent = _currentMonthSpent;
    final definedAmount = widget.budgetModel.definedAmount;
    final currencySymbol = widget.budgetModel.currency.symbol;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: InsightsHeader(
              selectedMonth: _selectedMonth,
              onMonthChanged: (date) {
                setState(() => _selectedMonth = date);
                widget.onMonthChanged?.call(date);
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppConstants.spacingLarge)),
          SliverToBoxAdapter(
            child: _AnimatedSection(
              controller: _staggerController,
              index: 0,
              total: 11,
              child: SpendingVelocitySection(budgetModel: widget.budgetModel, selectedMonth: _selectedMonth),
            ),
          ),
          SliverToBoxAdapter(
            child: _AnimatedSection(
              controller: _staggerController,
              index: 1,
              total: 11,
              child: BudgetHealthSection(
                spent: currentMonthSpent,
                definedAmount: definedAmount,
                currencySymbol: currencySymbol,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _AnimatedSection(
              controller: _staggerController,
              index: 2,
              total: 11,
              child: MonthComparisonChart(budgetModel: widget.budgetModel, selectedMonth: _selectedMonth),
            ),
          ),
          SliverToBoxAdapter(
            child: _AnimatedSection(
              controller: _staggerController,
              index: 3,
              total: 11,
              child: SpendingCategoryChart(budgetModel: widget.budgetModel, selectedMonth: _selectedMonth),
            ),
          ),
          SliverToBoxAdapter(
            child: _AnimatedSection(
              controller: _staggerController,
              index: 4,
              total: 11,
              child: DailySpendingChart(budgetModel: widget.budgetModel, selectedMonth: _selectedMonth),
            ),
          ),
          SliverToBoxAdapter(
            child: _AnimatedSection(
              controller: _staggerController,
              index: 5,
              total: 11,
              child: TransactionStatsSection(budgetModel: widget.budgetModel, selectedMonth: _selectedMonth),
            ),
          ),
          SliverToBoxAdapter(
            child: _AnimatedSection(
              controller: _staggerController,
              index: 6,
              total: 11,
              child: BiggestExpenseSection(budgetModel: widget.budgetModel, selectedMonth: _selectedMonth),
            ),
          ),
          SliverToBoxAdapter(
            child: _AnimatedSection(
              controller: _staggerController,
              index: 7,
              total: 11,
              child: PaymentMethodSection(budgetModel: widget.budgetModel, selectedMonth: _selectedMonth),
            ),
          ),
          SliverToBoxAdapter(
            child: _AnimatedSection(
              controller: _staggerController,
              index: 8,
              total: 11,
              child: WeekendVsWeekdaySection(budgetModel: widget.budgetModel, selectedMonth: _selectedMonth),
            ),
          ),
          SliverToBoxAdapter(
            child: _AnimatedSection(
              controller: _staggerController,
              index: 9,
              total: 11,
              child: NoSpendDaysSection(budgetModel: widget.budgetModel, selectedMonth: _selectedMonth),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppConstants.defaultPadding)),
        ],
      ),
    );
  }

  double get _currentMonthSpent {
    final transactions = widget.budgetModel.categories
        .expand((c) => c.transactions)
        .where((t) => t.date.year == _selectedMonth.year && t.date.month == _selectedMonth.month)
        .toList();

    return transactions.fold<double>(0, (sum, t) => sum + t.amount);
  }
}

class _AnimatedSection extends StatelessWidget {
  final AnimationController controller;
  final int index;
  final int total;
  final Widget child;

  const _AnimatedSection({required this.controller, required this.index, required this.total, required this.child});

  @override
  Widget build(BuildContext context) {
    final start = index / total;
    final end = (index + 1) / total;
    final interval = Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0), curve: Curves.easeOut);

    final animation = CurvedAnimation(parent: controller, curve: interval);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final slideOffset = Tween<Offset>(begin: const Offset(0.0, 0.15), end: Offset.zero).transform(animation.value);
        final fadeOpacity = CurvedAnimation(parent: controller, curve: interval);

        return Transform.translate(
          offset: Offset(0, slideOffset.dy * 30),
          child: Opacity(
            opacity: fadeOpacity.value,
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingLarge),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
