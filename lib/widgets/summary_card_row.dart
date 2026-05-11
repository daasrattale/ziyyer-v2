import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:ziyyer/config/theme.dart';
import 'package:ziyyer/constants/app_constants.dart';

class SummaryCardsRow extends StatelessWidget {
  final double incomeAmount;
  final int incomeSources;
  final double paymentsAmount;

  const SummaryCardsRow({super.key, required this.incomeAmount, required this.incomeSources, required this.paymentsAmount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              title: 'INCOME',
              amount: incomeAmount,
              subtitle: '$incomeSources sources',
              iconData: FeatherIcons.trendingUp,
              iconColor: AppColors.income,
              iconBackgroundColor: AppColors.income.withAlpha(30),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _SummaryCard(
              title: 'PAYMENTS',
              amount: paymentsAmount,
              subtitle: 'This month',
              iconData: FeatherIcons.trendingDown,
              iconColor: AppColors.expense,
              iconBackgroundColor: AppColors.expense.withAlpha(30),
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
    final formattedAmount = amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(color: AppColors.surface(context), borderRadius: BorderRadius.circular(24.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(color: iconBackgroundColor, shape: BoxShape.circle),
            child: Icon(iconData, color: iconColor, size: 20),
          ),
          const SizedBox(height: 20),
          Text(title, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.textSecondary(context), letterSpacing: 1.2)),
          const SizedBox(height: 8),
          Text('\$$formattedAmount', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary(context))),
        ],
      ),
    );
  }
}
