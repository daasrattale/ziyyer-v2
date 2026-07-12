import 'package:flutter/material.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/transaction_amount_section.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/transaction_category_section.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/transaction_date_section.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/transaction_description_section.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/transaction_title_section.dart';
import 'package:ziyyer/features/budget_setup/widgets/budget_setup_widget.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/models/category_model.dart';
import 'package:ziyyer/shared/services/budget_service.dart';
import 'package:ziyyer/shared/services/transaction_service.dart';
import 'package:ziyyer/shared/ui/loader.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/shared/utils/toaster.dart';

class AddExpenseWidget extends StatefulWidget {
  const AddExpenseWidget({super.key});

  @override
  State<AddExpenseWidget> createState() => _AddExpenseWidgetState();
}

class _AddExpenseWidgetState extends State<AddExpenseWidget> {
  final BudgetService _budgetService = BudgetService();
  final TransactionService _transactionService = TransactionService();

  late final Stream<BudgetModel?> _budgetStream;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  ScrollController scrollController = ScrollController();

  int? selectedCategoryId;
  DateTime selectedDate = DateTime.now();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _budgetStream = _budgetService.watch();
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
      Toaster.error(AppLocalizations.of(context)!.expenseAmountError);
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

      setState(() {
        amountController.text = '';
        descriptionController.text = '';
        selectedCategoryId = null;
      });

      Toaster.success(AppLocalizations.of(context)!.expenseSavedSuccess);
      scrollController.animateTo(0, duration: Duration(milliseconds: 500), curve: Easing.linear);
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
        stream: _budgetStream,
        builder: (context, snapshot) {
          final budget = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting && budget == null) {
            return const Loader();
          }

          if (budget == null && snapshot.connectionState == ConnectionState.done) {
            return const BudgetSetupWidget();
          }

          if (budget == null) {
            return const SizedBox.shrink();
          }

          final categories = budget.categories;
          _ensureFallbackCategory(categories);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TransactionTitleSection(),
                const SizedBox(height: 24),
                TransactionAmountSection(amountController: amountController, currencySymbol: budget.currency.symbol),
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
                    child: Text(isSaving ? AppLocalizations.of(context)!.saving : AppLocalizations.of(context)!.save),
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
