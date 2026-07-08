import 'package:flutter/material.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/transaction_amount_section.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/transaction_category_section.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/transaction_date_section.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/transaction_description_section.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/transaction_title_section.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/models/category_model.dart';
import 'package:ziyyer/shared/services/budget_service.dart';
import 'package:ziyyer/shared/services/transaction_service.dart';
import 'package:ziyyer/shared/utils/toaster.dart';

class AddExpenseWidget extends StatefulWidget {
  const AddExpenseWidget({super.key});

  @override
  State<AddExpenseWidget> createState() => _AddExpenseWidgetState();
}

class _AddExpenseWidgetState extends State<AddExpenseWidget> {
  final BudgetService _budgetService = BudgetService();
  final TransactionService _transactionService = TransactionService();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  int? selectedCategoryId;
  DateTime selectedDate = DateTime.now();
  bool isSaving = false;

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
      await _transactionService.persist(
        amount: amount,
        categoryId: selectedCategoryId,
        description: descriptionController.text.trim(),
        date: selectedDate,
      );

      if (!mounted) return;

      Toaster.success("Expense saved successfully");
      amountController.text = '';
      descriptionController.text = '';
      selectedCategoryId = null;
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  void _ensureFallbackCategory(List<CategoryModel> categories) {
    if (selectedCategoryId != null || categories.isEmpty) return;

    final otherCategory = categories.where((c) => c.name.toLowerCase() == 'other').toList();
    selectedCategoryId = otherCategory.isNotEmpty ? otherCategory.first.id : categories.first.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<BudgetModel?>(
        stream: _budgetService.watch(),
        builder: (context, snapshot) {
          final budget = snapshot.data;
          final categories = budget?.categories ?? const <CategoryModel>[];

          _ensureFallbackCategory(categories);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TransactionTitleSection(),
                const SizedBox(height: 24),
                TransactionAmountSection(amountController: amountController),
                const SizedBox(height: 24),
                TransactionCategorySection(
                  categories: categories.reversed.toList(),
                  selectedCategoryId: selectedCategoryId,
                  onCategoryChanged: (categoryId) {
                    setState(() {
                      selectedCategoryId = categoryId;
                    });
                  },
                ),
                const SizedBox(height: 24),
                TransactionDescriptionSection(descriptionController: descriptionController),
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
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: isSaving ? null : _submit,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                    child: Text(isSaving ? 'Saving...' : 'Save expense'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
