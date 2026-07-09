import 'package:flutter/material.dart';
import 'package:ziyyer/features/transactions_list/widgets/transaction_list_widgets.dart';
import 'package:ziyyer/shared/models/category_model.dart';
import 'package:ziyyer/shared/models/transaction_model.dart';
import 'package:ziyyer/shared/services/service_locator.dart';

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

class TransactionsScreen extends StatefulWidget {
  final TransactionsScreenArgs args;

  const TransactionsScreen({super.key, required this.args});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late List<TransactionModel> _transactions;

  @override
  void initState() {
    super.initState();
    _transactions = List<TransactionModel>.from(widget.args.transactions);
  }

  void _handleDelete(TransactionModel deletedTransaction) {
    setState(() {
      _transactions.removeWhere((item) => item.id == deletedTransaction.id);
    });
    ServiceLocator.transactionService.delete(deletedTransaction);
  }

  void _handleEdit(TransactionModel updatedTransaction) {
    setState(() {
      final index = _transactions.indexWhere((item) => item.id == updatedTransaction.id);
      if (index != -1) {
        _transactions[index] = updatedTransaction;
      }
    });
    //todo: add service update function
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: TransactionListWidgets(
        transactions: _transactions,
        categories: widget.args.categories,
        currencySymbol: widget.args.currencySymbol,
        onDeleteConfirmed: _handleDelete,
        onEdit: _handleEdit,
      ),
    );
  }
}
