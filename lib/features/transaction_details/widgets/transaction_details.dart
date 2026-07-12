import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/shared/extensions/datetime_extensions.dart';
import 'package:ziyyer/shared/extensions/string_extensions.dart';
import 'package:ziyyer/shared/models/category_model.dart';
import 'package:ziyyer/shared/models/transaction_model.dart';
import 'package:ziyyer/theme.dart';

class TransactionDetailsResult {
  final TransactionModel? updatedTransaction;
  final int? deletedTransactionId;

  const TransactionDetailsResult({this.updatedTransaction, this.deletedTransactionId});

  bool get wasDeleted => deletedTransactionId != null;
  bool get wasEdited => updatedTransaction != null;
}

class TransactionDetailsWidget extends StatelessWidget {
  final TransactionModel transaction;
  final CategoryModel? category;
  final String currencySymbol;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionDetailsWidget({
    super.key,
    required this.transaction,
    required this.category,
    required this.currencySymbol,
    this.onEdit,
    this.onDelete,
  });

  String _formatAmount() {
    return '-$currencySymbol${transaction.amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = category?.name ?? AppLocalizations.of(context)!.other;
    final categoryColor = AppColors.categoryColorFor(categoryName);
    final categoryIcon = AppIcons.categoryIconFor(categoryName);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(categoryIcon, size: 20, color: categoryColor),
            ),
            const SizedBox(height: 28),
            Text(
              categoryName.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 2.2,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              (transaction.description ?? AppLocalizations.of(context)!.noDescription),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              _formatAmount(),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 36),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface(context),
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius - 4),
              ),
              child: Column(
                children: [
                  _DetailsRow(label: AppLocalizations.of(context)!.type, value: AppLocalizations.of(context)!.expense),
                  _DetailsDivider(),
                  _DetailsRow(label: AppLocalizations.of(context)!.category, value: categoryName),
                  _DetailsDivider(),
                  _DetailsRow(label: AppLocalizations.of(context)!.time, value: transaction.date.fullDateTime(context)),
                  // _DetailsDivider(),
                  // _DetailsRow(label: 'Reference', value: _formatReference()),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: Text(AppLocalizations.of(context)!.delete),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: AppColors.expenseColor(context),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.maxBorderRadius)),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(AppLocalizations.of(context)!.edit),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: AppColors.accent(context),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.maxBorderRadius)),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailsRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary(context), fontWeight: FontWeight.normal),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value.capitalizeFirst(),
              textAlign: TextAlign.left,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: AppColors.textPrimary(context)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8EC));
  }
}
