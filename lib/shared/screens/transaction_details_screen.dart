import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziyyer/features/transaction_details/widgets/transaction_details.dart';
import 'package:ziyyer/shared/models/category_model.dart';
import 'package:ziyyer/shared/models/transaction_model.dart';
import 'package:ziyyer/shared/screens/edit_expense_screen.dart';
import 'package:ziyyer/theme.dart';

class TransactionsDetailsScreenArgs {
  final TransactionModel transaction;
  final List<CategoryModel> categories;
  final String currencySymbol;
  final ValueChanged<TransactionModel>? onEdit;
  final ValueChanged<TransactionModel>? onDeleteConfirmed;

  const TransactionsDetailsScreenArgs({
    required this.transaction,
    required this.categories,
    required this.currencySymbol,
    this.onEdit,
    this.onDeleteConfirmed,
  });
}

class TransactionsDetailsScreen extends StatelessWidget {
  final TransactionsDetailsScreenArgs args;

  const TransactionsDetailsScreen({super.key, required this.args});

  CategoryModel? _findCategory() {
    for (final category in args.categories) {
      if (category.id == args.transaction.categoryId) return category;
    }
    return null;
  }

  void _navigateToEdit(BuildContext context) async {
    final result = await context.pushNamed<bool>(
      'edit-expense',
      extra: EditExpenseScreenArgs(
        transaction: args.transaction,
        categories: args.categories,
        currencySymbol: args.currencySymbol,
      ),
    );

    if (result == true && context.mounted) {
      args.onEdit?.call(args.transaction);
      context.pop();
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete transaction?'),
          content: const Text('This action cannot be undone.'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      args.onDeleteConfirmed?.call(args.transaction);
      if (context.mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: TransactionDetailsWidget(
        transaction: args.transaction,
        category: _findCategory(),
        currencySymbol: args.currencySymbol,
        onEdit: () => _navigateToEdit(context),
        onDelete: () => _confirmDelete(context),
      ),
    );
  }
}
