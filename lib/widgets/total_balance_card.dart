import 'package:flutter/material.dart';
import 'package:ziyyer/config/theme.dart';
import 'package:ziyyer/constants/app_constants.dart';
import 'package:ziyyer/constants/app_icons.dart';

class TotalBalanceCard extends StatelessWidget {
  final double totalBalance;
  final double income;
  final double payments;
  final double percentageChange;
  final String currency;

  const TotalBalanceCard({
    super.key,
    required this.totalBalance,
    required this.income,
    required this.payments,
    required this.percentageChange,
    this.currency = 'USD',
  });

  @override
  Widget build(BuildContext context) {
    final String balanceStr = '\$${totalBalance.toStringAsFixed(2).replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}';
    final List<String> balanceParts = balanceStr.split('.');
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.screenMargin, vertical: AppConstants.spacingMedium),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.accentColor(context),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF233253).withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title and Currency Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL BALANCE',
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.darkTextPrimary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  currency,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.darkTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                balanceParts[0],
                style: textTheme.displayLarge?.copyWith(
                  color: AppColors.darkTextPrimary,
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
              Text(
                '.${balanceParts[1]}',
                style: textTheme.headlineSmall?.copyWith(
                  color: AppColors.darkTextPrimary.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingExtraLarge),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  percentageChange >= 0 ? AppIcons.arrowUpRight : AppIcons.arrowDownRight,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  '${percentageChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(1)}% from last month',
                  style: textTheme.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Subtle Divider
          Divider(color: Colors.white.withValues(alpha: 0.14), height: 1),
          const SizedBox(height: 24),
          // Bottom Row: Income and Payments breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildSummaryColumn(
                  context,
                  'INCOME',
                  income,
                  CrossAxisAlignment.start,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryColumn(
                  context,
                  'PAYMENTS',
                  payments,
                  CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryColumn(
    BuildContext context,
    String title,
    double amount,
    CrossAxisAlignment alignment,
  ) {
    final formattedAmount = amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    final amountParts = formattedAmount.split('.');
    final textTheme = Theme.of(context).textTheme;
    final isEnd = alignment == CrossAxisAlignment.end;

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          textAlign: isEnd ? TextAlign.end : TextAlign.start,
          style: textTheme.labelLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            letterSpacing: 2.2,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '\$${amountParts[0]}',
              textAlign: isEnd ? TextAlign.end : TextAlign.start,
              style: textTheme.headlineSmall?.copyWith(
                color: AppColors.darkTextPrimary,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
            ),
            Text(
              '.${amountParts[1]}',
              style: textTheme.labelMedium?.copyWith(
                color: AppColors.darkTextPrimary.withValues(alpha: 0.8),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
