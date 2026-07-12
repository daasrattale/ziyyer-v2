import 'package:flutter/material.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ziyyer/features/transactions_list/widgets/transaction_list_widgets.dart';
import 'package:ziyyer/shared/models/category_model.dart';
import 'package:ziyyer/shared/models/transaction_model.dart';
import 'package:ziyyer/shared/screens/edit_expense_screen.dart';
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

  Future<void> _handleEdit(TransactionModel transaction) async {
    final updated = await context.pushNamed<TransactionModel>(
      'edit-expense',
      extra: EditExpenseScreenArgs(
        transaction: transaction,
        categories: widget.args.categories,
        currencySymbol: widget.args.currencySymbol,
      ),
    );

    if (updated != null && mounted) {
      setState(() {
        final index = _transactions.indexWhere((t) => t.id == updated.id);
        if (index != -1) {
          _transactions[index] = updated;
        }
      });
      widget.args.onEdit?.call(updated);
    }
  }

  void _handleTransactionUpdated(TransactionModel updated) {
    setState(() {
      final index = _transactions.indexWhere((t) => t.id == updated.id);
      if (index != -1) {
        _transactions[index] = updated;
      }
    });
    widget.args.onEdit?.call(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.transactionsTitle)),
      body: TransactionListWidgets(
        transactions: _transactions,
        categories: widget.args.categories,
        currencySymbol: widget.args.currencySymbol,
        onDeleteConfirmed: _handleDelete,
        onEdit: _handleEdit,
        onTransactionUpdated: _handleTransactionUpdated,
      ),
    );
  }
}
