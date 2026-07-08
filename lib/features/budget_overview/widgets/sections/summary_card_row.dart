import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/theme.dart';

class SummaryCardsRow extends StatelessWidget {
  final double incomeAmount;
  final double transactionsAmount;

  const SummaryCardsRow({super.key, required this.incomeAmount, required this.transactionsAmount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenMargin),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              title: 'INCOME',
              amount: incomeAmount,
              subtitle: 'Allocated',
              iconData: AppIcons.trendingUp,
              iconColor: AppColors.income,
              iconBackgroundColor: AppColors.income.withAlpha(20),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMedium),
          Expanded(
            child: _SummaryCard(
              title: 'TRANSACTIONS',
              amount: transactionsAmount,
              subtitle: 'This month',
              iconData: AppIcons.trendingDown,
              iconColor: AppColors.expense,
              iconBackgroundColor: AppColors.expense.withAlpha(20),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final String subtitle;
  final IconData iconData;
  final Color iconColor;
  final Color iconBackgroundColor;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.iconData,
    required this.iconColor,
    required this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final formattedAmount = amount.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius - 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(color: iconBackgroundColor, shape: BoxShape.circle),
            child: Icon(iconData, color: iconColor, size: 20),
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: AppColors.textSecondary(context), letterSpacing: 1.2),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            '\$$formattedAmount',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary(context)),
          ),
        ],
      ),
    );
  }
}
