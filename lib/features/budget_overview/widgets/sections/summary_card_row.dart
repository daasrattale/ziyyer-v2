import 'package:flutter/material.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/shared/extensions/datetime_extensions.dart';
import 'package:ziyyer/shared/models/currency_model.dart';
import 'package:ziyyer/theme.dart';

class SummaryCardsRow extends StatelessWidget {
  final double incomeAmount;
  final double transactionsAmount;
  final CurrencyModel currencyModel;

  const SummaryCardsRow({
    super.key,
    required this.incomeAmount,
    required this.transactionsAmount,
    required this.currencyModel,
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenMargin),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              title: AppLocalizations.of(context)!.allocated.toUpperCase(),
              amount: incomeAmount,
              subtitle: now.monthAndYear(context),
              iconData: AppIcons.budget,
              iconColor: AppColors.income,
              iconBackgroundColor: AppColors.income.withAlpha(20),
              currencySymbol: currencyModel.symbol,
            ),
          ),
          const SizedBox(width: AppConstants.spacingMedium),
          Expanded(
            child: _SummaryCard(
              title: AppLocalizations.of(context)!.transactions.toUpperCase(),
              amount: transactionsAmount,
              subtitle: now.monthAndYear(context),
              iconData: AppIcons.transaction,
              iconColor: AppColors.expense,
              iconBackgroundColor: AppColors.expense.withAlpha(20),
              currencySymbol: currencyModel.symbol,
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
  final String currencySymbol;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.iconData,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.currencySymbol,
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
            '$currencySymbol$formattedAmount',
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
