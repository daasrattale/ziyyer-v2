import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziyyer/features/transactions_list/widgets/transaction_list_widgets.dart';
import 'package:ziyyer/shared/models/category_model.dart';
import 'package:ziyyer/shared/models/transaction_model.dart';

class TransactionsScreenArgs {
  final List<TransactionModel> transactions;
  final List<CategoryModel> categories;
  final ValueChanged<TransactionModel>? onEdit;
  final ValueChanged<TransactionModel>? onDeleteConfirmed;
  final String currencySymbol;

  const TransactionsScreenArgs({
    required this.transactions,
    required this.categories,
    this.onEdit,
    this.onDeleteConfirmed,
    required this.currencySymbol,
  });
}

class TransactionsScreen extends StatelessWidget {
  final TransactionsScreenArgs args;

  const TransactionsScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text('Transactions'),
      ),
      body: TransactionListWidgets(
        transactions: args.transactions,
        categories: args.categories,
        currencySymbol: args.currencySymbol,
        onEdit: args.onEdit,
        onDeleteConfirmed: args.onDeleteConfirmed,
      ),
    );
  }
}
