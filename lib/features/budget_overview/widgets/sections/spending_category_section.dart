import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/shared/extensions/string_extensions.dart';
import 'package:ziyyer/shared/models/category_model.dart';
import 'package:ziyyer/shared/models/currency_model.dart';
import 'package:ziyyer/shared/screens/transactions_screen.dart';
import 'package:ziyyer/shared/services/service_locator.dart';
import 'package:ziyyer/theme.dart';

class SpendingCategorySection extends StatelessWidget {
  final List<CategoryModel> categories;
  final CurrencyModel currencyModel;
  const SpendingCategorySection({super.key, required this.categories, required this.currencyModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.screenMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                'Spending by category',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMedium),

          Column(
            spacing: AppConstants.spacingMedium,
            children: categories.reversed
                .map(
                  (category) => _CategoryItem(
                    iconData: AppIcons.categoryIconFor(category.name),
                    title: category.name.capitalizeFirst(),
                    spent: category.realAmount,
                    budget: category.definedAmount,
                    currencySymbol: currencyModel.symbol,
                    baseColor: AppColors.categoryColorFor(category.name), // Green tone
                    isFirst: true,
                    onTap: () {
                      context.pushNamed(
                        'transactions',
                        extra: TransactionsScreenArgs(
                          transactions: category.transactions,
                          categories: categories,
                          currencySymbol: currencyModel.symbol,
                          onEdit: (transaction) {
                            // todo: add edit function
                          },
                          onDeleteConfirmed: (transaction) {
                            ServiceLocator.transactionService.delete(transaction);
                          },
                        ),
                      );
                    },
                  ),
                )
                .toList(),
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
  final String currencySymbol;
  final bool isFirst;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.iconData,
    required this.title,
    required this.spent,
    required this.budget,
    required this.baseColor,
    required this.onTap,
    required this.currencySymbol,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = spent == 0 ? 0 : (spent / budget).clamp(0.0, 1.0);

    final bool isOverBudget = spent > budget;
    final Color barColor = isOverBudget ? AppColors.expense : baseColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          border: Border.all(color: baseColor.withAlpha(40), width: 1),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMedium),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon Container
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(color: baseColor.withAlpha(40), shape: BoxShape.circle),
                    child: Icon(iconData, color: baseColor, size: 16),
                  ),
                  const SizedBox(width: AppConstants.spacingMedium),

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
                            Text(
                              title,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '$currencySymbol${spent.toInt()}',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isOverBudget ? AppColors.expense : AppColors.textPrimary(context),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' / $currencySymbol${budget.toInt()}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary(context)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spacingExtraSmall),

                        Container(
                          height: 6,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.divider(context).withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
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
          ],
        ),
      ),
    );
  }
}
