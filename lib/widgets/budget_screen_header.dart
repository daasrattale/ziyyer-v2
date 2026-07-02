import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/theme.dart';

class BudgetScreenHeader extends StatelessWidget {
  const BudgetScreenHeader({
    super.key,
    required this.totalBudget,
    required this.totalSpent,
    required this.allocated,
    required this.unallocated,
    required this.currency,
    required this.onAddPressed,
    required this.onEditPressed,
  });

  final double totalBudget;
  final double totalSpent;
  final double allocated;
  final double unallocated;
  final String currency;
  final VoidCallback onAddPressed;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final usedRatio = totalBudget <= 0 ? 0.0 : (totalSpent / totalBudget).clamp(0.0, 1.0);

    final allocatedRatio = totalBudget <= 0 ? 0.0 : (allocated / totalBudget).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenMargin, vertical: AppConstants.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BudgetHeaderTopBar(onAddPressed: onAddPressed),
          const SizedBox(height: AppConstants.spacingLarge),
          _BudgetSummaryCard(
            totalBudget: totalBudget,
            totalSpent: totalSpent,
            usedRatio: usedRatio,
            allocated: allocated,
            allocatedRatio: allocatedRatio,
            unallocated: unallocated,
            currency: currency,
            onEditPressed: onEditPressed,
            backgroundColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _BudgetHeaderTopBar extends StatelessWidget {
  const _BudgetHeaderTopBar({required this.onAddPressed});

  final VoidCallback onAddPressed;

  String _formatMonth() {
    final date = DateTime.now();

    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatMonth(),
                style: textTheme.labelLarge?.copyWith(color: AppColors.textSecondary(context), fontWeight: FontWeight.w500, letterSpacing: 0.3),
              ),
              const SizedBox(height: AppConstants.spacingExtraSmall),
              Text(
                'Budgets',
                style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary(context), letterSpacing: -0.5),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface(context),
            border: Border.all(color: AppColors.background(context), width: 1),
          ),
          child: IconButton(
            icon: Icon(Icons.add, size: 20, color: AppColors.textPrimary(context)),
            onPressed: onAddPressed,
            splashRadius: 24,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          ),
        ),
      ],
    );
  }
}

class _BudgetSummaryCard extends StatelessWidget {
  const _BudgetSummaryCard({
    required this.totalBudget,
    required this.totalSpent,
    required this.usedRatio,
    required this.allocated,
    required this.allocatedRatio,
    required this.unallocated,
    required this.currency,
    required this.onEditPressed,
    required this.backgroundColor,
  });

  final double totalBudget;
  final double totalSpent;
  final double usedRatio;
  final double allocated;
  final double allocatedRatio;
  final double unallocated;
  final String currency;
  final VoidCallback onEditPressed;
  final Color backgroundColor;

  String _currency(double value) {
    return '${value.toStringAsFixed(2).replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")} $currency';
  }

  String _percent(double value) {
    return '${(value * 100).round()}%';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final onCardColor = Colors.white;
    final mutedColor = Colors.white.withValues(alpha: 0.70);
    final dividerColor = Colors.white.withValues(alpha: 0.14);
    final progressTrackColor = Colors.white.withValues(alpha: 0.16);
    final progressValueColor = Colors.white.withValues(alpha: 0.80);
    final editChipColor = Colors.white.withValues(alpha: 0.10);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        boxShadow: [BoxShadow(color: const Color(0xFF233253).withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'TOTAL MONTHLY BUDGET',
                  style: textTheme.labelSmall?.copyWith(color: AppColors.darkTextPrimary, fontWeight: FontWeight.w600, letterSpacing: 1.5),
                ),
              ),
              _EditPillButton(label: 'Edit', onPressed: onEditPressed, backgroundColor: editChipColor, foregroundColor: onCardColor),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _currency(totalBudget).split('.')[0],
                style: textTheme.displayLarge?.copyWith(color: onCardColor, fontWeight: FontWeight.w500, height: 1),
              ),
              Text(
                '.${_currency(totalBudget).split('.')[1]}',
                style: textTheme.headlineSmall?.copyWith(color: onCardColor.withValues(alpha: 0.8), fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingExtraLarge),
          _BudgetProgressBar(value: usedRatio, trackColor: progressTrackColor, valueColor: progressValueColor),
          const SizedBox(height: AppConstants.spacingMedium),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Spent ${_currency(totalSpent)}',
                  style: textTheme.labelMedium?.copyWith(color: mutedColor, fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                '${_percent(usedRatio)} used',
                style: textTheme.labelMedium?.copyWith(color: mutedColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLarge),
          Divider(color: dividerColor, height: 1),
          const SizedBox(height: AppConstants.spacingLarge),
          Row(
            children: [
              Expanded(
                child: _BudgetStatBlock(
                  label: 'ALLOCATED',
                  value: _currency(allocated),
                  subtitle: '${_percent(allocatedRatio)} of total',
                  alignment: CrossAxisAlignment.start,
                  textColor: onCardColor,
                  mutedColor: mutedColor,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: _BudgetStatBlock(
                  label: 'UNALLOCATED',
                  value: _currency(unallocated),
                  subtitle: 'Available to assign',
                  alignment: CrossAxisAlignment.end,
                  textColor: onCardColor,
                  mutedColor: mutedColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BudgetStatBlock extends StatelessWidget {
  const _BudgetStatBlock({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.alignment,
    required this.textColor,
    required this.mutedColor,
  });

  final String label;
  final String value;
  final String subtitle;
  final CrossAxisAlignment alignment;
  final Color textColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isEnd = alignment == CrossAxisAlignment.end;

    final amountParts = value.split('.');

    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          textAlign: isEnd ? TextAlign.end : TextAlign.start,
          style: textTheme.labelLarge?.copyWith(color: mutedColor, letterSpacing: 2.2, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              amountParts[0],
              textAlign: isEnd ? TextAlign.end : TextAlign.start,
              style: textTheme.headlineSmall?.copyWith(color: textColor, fontWeight: FontWeight.bold, height: 1),
            ),
            if (amountParts.length > 1)
              Text(
                '.${amountParts[1]}',
                style: textTheme.labelMedium?.copyWith(color: textColor.withValues(alpha: 0.8), fontWeight: FontWeight.bold),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: isEnd ? TextAlign.end : TextAlign.start,
          style: textTheme.labelMedium?.copyWith(color: mutedColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _BudgetProgressBar extends StatelessWidget {
  const _BudgetProgressBar({required this.value, required this.trackColor, required this.valueColor});

  final double value;
  final Color trackColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 10,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth * math.max(0, math.min(1, value));
            return Stack(
              children: [
                Container(color: trackColor),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  width: width,
                  decoration: BoxDecoration(color: valueColor, borderRadius: BorderRadius.circular(999)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeaderCircleButton extends StatelessWidget {
  const _HeaderCircleButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(32),
        child: Ink(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Icon(icon, size: 34, color: colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _EditPillButton extends StatelessWidget {
  const _EditPillButton({required this.label, required this.onPressed, required this.backgroundColor, required this.foregroundColor});

  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(999)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_outlined, size: 18, color: foregroundColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: textTheme.labelLarge?.copyWith(color: foregroundColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
