import 'package:flutter/material.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/transaction_amount_section.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/transaction_category_section.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/transaction_date_section.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/transaction_description_section.dart';
import 'package:ziyyer/shared/models/category_model.dart';
import 'package:ziyyer/shared/models/transaction_model.dart';
import 'package:ziyyer/shared/services/transaction_service.dart';
import 'package:ziyyer/shared/utils/toaster.dart';

class EditExpenseWidget extends StatefulWidget {
  final TransactionModel transaction;
  final List<CategoryModel> categories;
  final String currencySymbol;

  const EditExpenseWidget({
    super.key,
    required this.transaction,
    required this.categories,
    required this.currencySymbol,
  });

  @override
  State<EditExpenseWidget> createState() => _EditExpenseWidgetState();
}

class _EditExpenseWidgetState extends State<EditExpenseWidget> {
  final TransactionService _transactionService = TransactionService();

  late final TextEditingController amountController;
  late final TextEditingController descriptionController;

  late int selectedCategoryId;
  late DateTime selectedDate;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: widget.transaction.amount.toString());
    descriptionController = TextEditingController(text: widget.transaction.description ?? '');
    selectedCategoryId = widget.transaction.categoryId;
    selectedDate = widget.transaction.date;
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = double.tryParse(amountController.text.trim().replaceAll(',', '.'));

    if (amount == null || amount <= 0) {
      Toaster.error("Expense amount must be greater than 0");
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await _transactionService.update(
        widget.transaction.copyWith(
          amount: amount,
          categoryId: selectedCategoryId,
          description: descriptionController.text.trim(),
          date: selectedDate,
        ),
      );

      if (!mounted) return;

      Toaster.success("Transaction updated successfully");
      Navigator.of(context).pop(true);
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Transaction'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            TransactionAmountSection(amountController: amountController, currencySymbol: widget.currencySymbol),
            const SizedBox(height: 24),
            TransactionCategorySection(
              categories: widget.categories.reversed.toList(),
              selectedCategoryId: selectedCategoryId,
              onCategoryChanged: (categoryId) {
                setState(() {
                  selectedCategoryId = categoryId ?? selectedCategoryId;
                });
              },
            ),
            const SizedBox(height: 24),
            TransactionDateSection(
              selectedDate: selectedDate,
              onDateChanged: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            const SizedBox(height: 24),
            TransactionDescriptionSection(descriptionController: descriptionController),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isSaving ? null : _submit,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: Text(isSaving ? 'Saving...' : 'Save'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
