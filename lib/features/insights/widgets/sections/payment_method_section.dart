import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/models/transaction_model.dart';
import 'package:ziyyer/shared/utils/amount_formatter.dart';
import 'package:ziyyer/theme.dart';

class PaymentMethodSection extends StatelessWidget {
  final BudgetModel budgetModel;
  final DateTime selectedMonth;

  const PaymentMethodSection({
    super.key,
    required this.budgetModel,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final transactions = _filteredTransactions;
    final totalSpent = transactions.fold<double>(0, (sum, t) => sum + t.amount);
    final methodBreakdown = _paymentMethodBreakdown;

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
              AppLocalizations.of(context)!.paymentMethods,
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            if (methodBreakdown.isEmpty)
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      height: 12,
                      child: Row(
                        children: methodBreakdown.map((entry) {
                          final percentage = totalSpent > 0 ? entry.$2 / totalSpent : 0.0;
                          return Expanded(
                            flex: (percentage * 1000).toInt().clamp(1, 1000),
                            child: Container(color: entry.$3),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingLarge),
                  ...methodBreakdown.map((entry) {
                    final method = entry.$1;
                    final amount = entry.$2;
                    final color = entry.$3;
                    final percentage = totalSpent > 0 ? (amount / totalSpent * 100) : 0.0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withAlpha(30),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _paymentIcon(method),
                              color: color,
                              size: 14,
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingMedium),
                          Expanded(
                            child: Text(
                              method,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                AmountFormatter.formatCurrency(amount, currency: budgetModel.currency),
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${percentage.toStringAsFixed(0)}%',
                                style: textTheme.labelSmall?.copyWith(
                                  color: AppColors.textSecondary(context),
                                ),
                              ),
                            ],
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

  IconData _paymentIcon(String method) {
    final lower = method.toLowerCase();
    if (lower.contains('cash')) return AppIcons.money;
    if (lower.contains('credit')) return AppIcons.receipt;
    if (lower.contains('debit')) return AppIcons.receipt;
    if (lower.contains('apple') || lower.contains('pay')) return AppIcons.plugZap;
    if (lower.contains('transfer')) return AppIcons.transaction;
    return AppIcons.money;
  }

  List<TransactionModel> get _filteredTransactions {
    return budgetModel.categories
        .expand((c) => c.transactions)
        .where((t) => t.date.year == selectedMonth.year && t.date.month == selectedMonth.month)
        .toList();
  }

  List<(String, double, Color)> get _paymentMethodBreakdown {
    final map = <String, double>{};

    for (final t in _filteredTransactions) {
      final method = t.paymentMethod ?? 'Other';
      map[method] = (map[method] ?? 0) + t.amount;
    }

    final entries = map.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final colors = [
      AppColors.accentLight,
      AppColors.info,
      AppColors.income,
      AppColors.warning,
      AppColors.expense,
    ];

    return entries.asMap().entries.map((entry) {
      final color = colors[entry.key % colors.length];
      return (entry.value.key, entry.value.value, color);
    }).toList();
  }
}
