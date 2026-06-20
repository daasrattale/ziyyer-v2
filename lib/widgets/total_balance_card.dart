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
    final String balanceStr = totalBalance.toStringAsFixed(2);
    final List<String> balanceParts = balanceStr.split('.');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding, vertical: AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding * 2),
      decoration: BoxDecoration(
        color: AppColors.accentColor(context),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        boxShadow: [BoxShadow(color: const Color(0xFF233253).withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10))],
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
                style: TextStyle(color: AppColors.darkTextPrimary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.5),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(color: AppColors.surface(context).withAlpha(10), borderRadius: BorderRadius.circular(16.0)),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      currency,
                      style: TextStyle(color: AppColors.darkTextPrimary, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                // Format with commas, e.g., 12,847
                balanceParts[0].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                style: const TextStyle(color: AppColors.darkTextPrimary, fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: -1.5),
              ),
              Text(
                '.${balanceParts[1]}',
                style: TextStyle(color: AppColors.darkTextPrimary, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(color: AppColors.surface(context).withAlpha(10), borderRadius: BorderRadius.circular(16.0)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(percentageChange >= 0 ? AppIcons.arrowUpRight : AppIcons.arrowDownRight, color: Colors.white, size: 14),
                const SizedBox(width: 6),
                Text(
                  '${percentageChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(1)}% from last month',
                  style: TextStyle(color: AppColors.darkTextPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Subtle Divider
          Divider(color: AppColors.darkTextPrimary, thickness: 1),

          const SizedBox(height: 16),

          // Bottom Row: Income and Payments breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryColumn('INCOME', income, CrossAxisAlignment.start),
              _buildSummaryColumn('PAYMENTS', payments, CrossAxisAlignment.end),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryColumn(String title, double amount, CrossAxisAlignment alignment) {
    final formattedAmount = amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          title,
          style: TextStyle(color: AppColors.darkTextPrimary, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2),
        ),
        Text(
          '\$$formattedAmount',
          style: const TextStyle(color: AppColors.darkTextPrimary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
