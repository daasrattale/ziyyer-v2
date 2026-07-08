import 'package:flutter/material.dart';
import 'package:ziyyer/features/add_expenses/widgets/add_expense_widget.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return AddExpenseWidget();
  }
}
