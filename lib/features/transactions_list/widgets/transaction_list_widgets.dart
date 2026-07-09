import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/features/transaction_details/widgets/transaction_details.dart';
import 'package:ziyyer/shared/extensions/datetime_extensions.dart';
import 'package:ziyyer/shared/models/category_model.dart';
import 'package:ziyyer/shared/models/transaction_model.dart';
import 'package:ziyyer/shared/screens/transaction_details_screen.dart';
import 'package:ziyyer/theme.dart';

class TransactionListWidgets extends StatefulWidget {
  final List<TransactionModel> transactions;
  final List<CategoryModel> categories;
  final ValueChanged<TransactionModel>? onEdit;
  final ValueChanged<TransactionModel>? onDeleteConfirmed;
  final String currencySymbol;
  final EdgeInsetsGeometry padding;

  const TransactionListWidgets({
    super.key,
    required this.transactions,
    required this.categories,
    required this.onEdit,
    required this.onDeleteConfirmed,
    required this.currencySymbol,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  });

  @override
  State<TransactionListWidgets> createState() => _TransactionListWidgetsState();
}

class _TransactionListWidgetsState extends State<TransactionListWidgets> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TransactionListWidgets oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Future<bool?> _showDeletePrompt(TransactionModel transaction) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete transaction?'),
          content: Text(
            'This will permanently remove "${transaction.description?.trim().isNotEmpty == true ? transaction.description!.trim() : 'this transaction'}".',
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  CategoryModel? _findCategory(int? categoryId) {
    if (categoryId == null) return null;

    for (final category in widget.categories) {
      if (category.id == categoryId) return category;
    }
    return null;
  }

  String _formatAmount(double amount) {
    return '- ${widget.currencySymbol}${amount.toStringAsFixed(2)}';
  }

  List<_TransactionListEntry> _buildGroupedEntries() {
    final entries = <_TransactionListEntry>[];
    String? currentMonthKey;

    for (final transaction in widget.transactions) {
      final monthKey = '${transaction.date.year}-${transaction.date.month}';

      if (monthKey != currentMonthKey) {
        currentMonthKey = monthKey;
        entries.add(_MonthHeaderEntry(transaction.date.monthAndYear()));
      }

      entries.add(_TransactionItemEntry(transaction));
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.transactions.isEmpty) {
      return Padding(
        padding: widget.padding,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE9E9E9)),
          ),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.receipt_long_rounded, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 14),
              Text(
                'No transactions yet',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Your saved expenses will appear here.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    final entries = _buildGroupedEntries();

    return ListView.separated(
      padding: widget.padding,
      itemCount: entries.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final entry = entries[index];

        if (entry is _MonthHeaderEntry) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 2),
            child: Text(
              entry.label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        }

        final transaction = (entry as _TransactionItemEntry).transaction;
        final category = _findCategory(transaction.categoryId);
        final categoryName = category?.name ?? 'Other';
        final categoryColor = AppColors.categoryColorFor(categoryName);
        final categoryIcon = AppIcons.categoryIconFor(categoryName);

        return Dismissible(
          key: ValueKey(transaction.id),
          background: _SwipeActionBackground(
            alignment: Alignment.centerLeft,
            color: AppColors.infoColor(context),
            icon: Icons.edit_rounded,
            label: 'Edit',
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          secondaryBackground: _SwipeActionBackground(
            alignment: Alignment.centerRight,
            color: AppColors.expenseColor(context),
            icon: Icons.delete_rounded,
            label: 'Delete',
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              widget.onEdit?.call(transaction);
              return false;
            }

            if (direction == DismissDirection.endToStart) {
              final confirmed = await _showDeletePrompt(transaction);
              return confirmed ?? false;
            }

            return false;
          },
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              final removed = transaction;
              setState(() {
                widget.transactions.removeWhere((item) => item.id == removed.id && item.createdAt == removed.createdAt);
              });
              widget.onDeleteConfirmed?.call(removed);
            }
          },
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                context.pushNamed<TransactionDetailsResult>(
                  'transaction-details',
                  extra: TransactionsDetailsScreenArgs(
                    transaction: transaction,
                    categories: widget.categories,
                    currencySymbol: widget.currencySymbol,
                    onEdit: widget.onEdit,
                    onDeleteConfirmed: widget.onDeleteConfirmed,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface(context),
                  borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: categoryColor.withValues(alpha: 0.12)),
                        child: Icon(categoryIcon, color: categoryColor, size: 18),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.description?.trim().isNotEmpty == true
                                  ? transaction.description!.trim()
                                  : categoryName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    transaction.date.prettyDate(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatAmount(transaction.amount),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

abstract class _TransactionListEntry {
  const _TransactionListEntry();
}

class _MonthHeaderEntry extends _TransactionListEntry {
  final String label;

  const _MonthHeaderEntry(this.label);
}

class _TransactionItemEntry extends _TransactionListEntry {
  final TransactionModel transaction;

  const _TransactionItemEntry(this.transaction);
}

class _SwipeActionBackground extends StatelessWidget {
  final Alignment alignment;
  final Color color;
  final IconData icon;
  final String label;
  final BorderRadius borderRadius;

  const _SwipeActionBackground({
    required this.alignment,
    required this.color,
    required this.icon,
    required this.label,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isLeft = alignment == Alignment.centerLeft;

    return Container(
      decoration: BoxDecoration(color: color, borderRadius: borderRadius),
      padding: EdgeInsets.only(left: isLeft ? 20 : 0, right: isLeft ? 0 : 20),
      alignment: alignment,
      child: Row(
        mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (!isLeft) ...[
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 8),
          ],
          Icon(icon, color: Colors.white, size: 22),
          if (isLeft) ...[
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ],
        ],
      ),
    );
  }
}
