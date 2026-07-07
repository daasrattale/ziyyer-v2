import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/theme.dart';

class BudgetSummary extends StatelessWidget {
  final BudgetModel budgetModel;

  const BudgetSummary({super.key, required this.budgetModel});

  @override
  Widget build(BuildContext context) {
    final String balanceStr = budgetModel.balance
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},");
    final List<String> balanceParts = balanceStr.split('.');

    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.screenMargin, vertical: AppConstants.spacingMedium),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppColors.accentColor(context),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              GestureDetector(
                onTap: () {
                  context.go("/budget");
                },
                child: Container(
                  padding: EdgeInsets.all(AppConstants.spacingMedium),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.surface(context)),
                  child: Icon(AppIcons.edit, size: 20, color: AppColors.accent(context)),
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
                budgetModel.currency.symbol,
                style: textTheme.displayLarge?.copyWith(
                  color: AppColors.darkTextPrimary,
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
              SizedBox(width: 4),
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
          SizedBox(height: AppConstants.spacingExtraLarge),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(AppIcons.arrowUpRight, color: Colors.white, size: 14),
                const SizedBox(width: 6),
                Text(
                  '+20% from last month',
                  style: textTheme.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: Colors.white.withValues(alpha: 0.14), height: 1),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildSummaryColumn(context, 'INCOME', budgetModel.definedAmount, CrossAxisAlignment.start),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryColumn(
                  context,
                  'PAYMENTS',
                  budgetModel.allocatedPayementsAmount,
                  CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryColumn(BuildContext context, String title, double amount, CrossAxisAlignment alignment) {
    final formattedAmount = amount
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
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
