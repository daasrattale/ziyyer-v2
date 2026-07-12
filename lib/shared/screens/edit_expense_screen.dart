import 'package:flutter/material.dart';
import 'package:ziyyer/features/add_expenses/widgets/edit_expense_widget.dart';
import 'package:ziyyer/shared/models/category_model.dart';
import 'package:ziyyer/shared/models/transaction_model.dart';

class EditExpenseScreenArgs {
  final TransactionModel transaction;
  final List<CategoryModel> categories;
  final String currencySymbol;

  const EditExpenseScreenArgs({
    required this.transaction,
    required this.categories,
    required this.currencySymbol,
  });
}

class EditExpenseScreen extends StatelessWidget {
  final EditExpenseScreenArgs args;

  const EditExpenseScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return EditExpenseWidget(
      transaction: args.transaction,
      categories: args.categories,
      currencySymbol: args.currencySymbol,
    );
  }
}
