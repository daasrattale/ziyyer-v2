import 'package:flutter/material.dart';
import 'package:ziyyer/config/theme.dart';
import 'package:ziyyer/constants/app_constants.dart';
import 'package:ziyyer/constants/app_icons.dart';

class SpendingCategorySection extends StatelessWidget {
  const SpendingCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('Spending by category', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to view all categories
                },
                child: Text(
                  'View all',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.accentColor(context), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Container for the list to give it the grouped card look
          Column(
            spacing: AppConstants.defaultPadding,
            children: [
              _CategoryItem(
                iconData: AppIcons.home,
                title: 'Housing',
                spent: 1200,
                budget: 1500,
                baseColor: const Color(0xFF2E8B57), // Green tone
                isFirst: true,
              ),
              _CategoryItem(
                iconData: AppIcons.coffee,
                title: 'Food & Dining',
                spent: 420,
                budget: 500,
                baseColor: const Color(0xFFDAA520), // Orange/Yellow tone
              ),
              _CategoryItem(
                iconData: AppIcons.truck,
                title: 'Transport',
                spent: 280,
                budget: 350,
                baseColor: const Color(0xFF2E8B57), // Green tone
              ),
              _CategoryItem(
                iconData: AppIcons.shoppingBag,
                title: 'Shopping',
                spent: 510,
                budget: 400,
                baseColor: AppColors.expense, // Red tone for over budget
              ),
              _CategoryItem(
                iconData: AppIcons.film,
                title: 'Entertainment',
                spent: 95,
                budget: 200,
                baseColor: const Color(0xFF2E8B57), // Green tone
                isLast: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final double spent;
  final double budget;
  final Color baseColor;
  final bool isFirst;
  final bool isLast;

  const _CategoryItem({
    required this.iconData,
    required this.title,
    required this.spent,
    required this.budget,
    required this.baseColor,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate progress ratio, capped at 1.0
    final double progress = (spent / budget).clamp(0.0, 1.0);

    // Check if over budget
    final bool isOverBudget = spent > budget;
    // Use the explicit base color unless it's over budget, then force the warning/expense color
    final Color barColor = isOverBudget ? AppColors.expense : baseColor;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: baseColor.withAlpha(40), width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(color: baseColor.withAlpha(40), shape: BoxShape.circle),
                  child: Icon(iconData, color: baseColor, size: 16),
                ),
                const SizedBox(width: 20),

                // Text and Progress Bar Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Amounts
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '\$${spent.toInt()}',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: isOverBudget ? AppColors.expense : AppColors.textPrimary(context),
                                  ),
                                ),
                                TextSpan(
                                  text: ' / \$${budget.toInt()}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary(context)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Custom Progress Bar
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(color: AppColors.divider(context).withValues(alpha: 0.5), borderRadius: BorderRadius.circular(3.0)),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress,
                          child: Container(
                            decoration: BoxDecoration(color: barColor, borderRadius: BorderRadius.circular(3.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Add divider if not the last item
          if (!isLast)
            Divider(
              height: 1,
              indent: 76, // Align with the start of the text
              endIndent: 20,
              color: AppColors.divider(context).withValues(alpha: 0.5),
            ),
        ],
      ),
    );
  }
}
