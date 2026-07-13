import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/shared/extensions/datetime_extensions.dart';
import 'package:ziyyer/theme.dart';

class InsightsHeader extends StatelessWidget {
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onMonthChanged;

  const InsightsHeader({
    super.key,
    required this.selectedMonth,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final isCurrentMonth = selectedMonth.year == now.year && selectedMonth.month == now.month;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.screenMargin,
        vertical: AppConstants.spacingMedium,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.insight,
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary(context),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: AppConstants.spacingExtraSmall),
              Text(
                selectedMonth.monthAndYear(context),
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _MonthArrow(
                icon: Icons.chevron_left,
                onTap: () {
                  final previousMonth = DateTime(
                    selectedMonth.year,
                    selectedMonth.month - 1,
                  );
                  onMonthChanged(previousMonth);
                },
              ),
              const SizedBox(width: AppConstants.spacingSmall),
              _MonthArrow(
                icon: Icons.chevron_right,
                onTap: isCurrentMonth ? null : () {
                  final nextMonth = DateTime(
                    selectedMonth.year,
                    selectedMonth.month + 1,
                  );
                  onMonthChanged(nextMonth);
                },
                isDisabled: isCurrentMonth,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDisabled;

  const _MonthArrow({
    required this.icon,
    this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface(context),
          border: Border.all(color: AppColors.background(context), width: 1),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDisabled
              ? AppColors.textHint(context)
              : AppColors.textPrimary(context),
        ),
      ),
    );
  }
}
