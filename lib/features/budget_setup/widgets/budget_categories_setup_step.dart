import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/models/category_model.dart';
import 'package:ziyyer/theme.dart';

class BudgetCategoriesSetupStep extends StatefulWidget {
  final Function(List<CategoryModel> categories) onCategoriesChanged;
  final BudgetModel budgetModel;

  const BudgetCategoriesSetupStep({super.key, required this.onCategoriesChanged, required this.budgetModel});

  @override
  State<BudgetCategoriesSetupStep> createState() => _BudgetCategoriesSetupStepState();
}

class _BudgetCategoriesSetupStepState extends State<BudgetCategoriesSetupStep> {
  final List<_CategoryRowData> _rows = [];

  @override
  void initState() {
    super.initState();

    final existingCategories = widget.budgetModel.categories;

    if (existingCategories.isNotEmpty) {
      _rows.addAll(
        existingCategories.map(
          (category) => _CategoryRowData(
            onChanged: _handleRowChanged,
            initialAmount: category.definedAmount.toString(),
            initialName: category.name,
          ),
        ),
      );
    }

    _rows.add(_CategoryRowData(onChanged: _handleRowChanged));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _notifyParent();
    });
  }

  void _handleRowChanged() {
    setState(() {});
    _notifyParent();
  }

  void _addEmptyRow() {
    setState(() {
      _rows.add(_CategoryRowData(onChanged: _handleRowChanged));
    });
    _notifyParent();
  }

  void _removeRow(int index) {
    if (_rows.length == 1) {
      _rows[index].nameController.clear();
      _rows[index].amountController.clear();
      _notifyParent();
      setState(() {});
      return;
    }

    final row = _rows.removeAt(index);
    row.dispose();

    setState(() {});
    _notifyParent();
  }

  void _notifyParent() {
    final now = DateTime.now();

    final categories = _rows
        .map(
          (row) => CategoryModel(
            id: 0,
            name: row.nameController.text.trim(),
            definedAmount: double.tryParse(row.amountController.text.trim().replaceAll(',', '.')) ?? 0.0,
            realAmount: 0.0,
            createdAt: now,
            updatedAt: now,
          ),
        )
        .where((category) => category.name.isNotEmpty || category.definedAmount > 0)
        .toList();

    widget.onCategoriesChanged(categories);
  }

  String _formatAmount(double value) {
    if (value == value.roundToDouble()) {
      return '${widget.budgetModel.currency.symbol} ${value.toInt()}';
    }
    return '${widget.budgetModel.currency.symbol} ${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Text(
          'Spending categories',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: AppColors.textPrimary(context)),
        ),
        const SizedBox(height: 8),
        Text(
          'Split your budget into categories like groceries or transport.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary(context), fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 24),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          child: Row(
            children: [
              Expanded(
                child: _SummaryValue(
                  label: 'CATEGORIES TOTAL',
                  value: _formatAmount(widget.budgetModel.allocatedCategoriesAmount),
                  alignment: CrossAxisAlignment.start,
                ),
              ),
              Expanded(
                child: _SummaryValue(
                  label: 'LEFT TO ALLOCATE',
                  value: _formatAmount(widget.budgetModel.unallocatedAmount),
                  alignment: CrossAxisAlignment.end,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Expanded(
          child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: _rows.length,
            itemBuilder: (context, index) {
              final row = _rows[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(color: AppColors.background(context), shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Icon(AppIcons.category, color: AppColors.textHint(context), size: 18),
                      ),
                      const SizedBox(width: 14),

                      Expanded(
                        child: TextField(
                          controller: row.nameController,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary(context),
                          ),
                          decoration: InputDecoration(
                            hintText: 'e.g. Groceries',
                            hintStyle: TextStyle(
                              color: AppColors.textHint(context),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      Container(
                        width: 128,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.background(context),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Text(
                              widget.budgetModel.currency.symbol,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF5B6170),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: row.amountController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary(context),
                                ),
                                decoration: InputDecoration(
                                  hintText: '0',
                                  hintStyle: TextStyle(
                                    color: AppColors.textHint(context),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeRow(index),
                        icon: Icon(AppIcons.trash, color: AppColors.expenseColor(context), size: 18),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        GestureDetector(
          onTap: _addEmptyRow,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(color: AppColors.surface(context), borderRadius: BorderRadius.circular(999)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(AppIcons.add, color: AppColors.textSecondary(context), size: 22),
                const SizedBox(width: 10),
                Text(
                  'Add another category',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary(context)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Optional · adjust categories later anytime',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: AppColors.textHint(context), fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}

class _SummaryValue extends StatelessWidget {
  final String label;
  final String value;
  final CrossAxisAlignment alignment;
  final TextAlign textAlign;

  const _SummaryValue({
    required this.label,
    required this.value,
    required this.alignment,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.8,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          textAlign: textAlign,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary(context)),
        ),
      ],
    );
  }
}

class _CategoryRowData {
  final VoidCallback onChanged;

  final TextEditingController nameController;
  final TextEditingController amountController;

  _CategoryRowData({required this.onChanged, String initialName = '', String initialAmount = ''})
    : nameController = TextEditingController(text: initialName),
      amountController = TextEditingController(text: initialAmount) {
    nameController.addListener(onChanged);
    amountController.addListener(onChanged);
  }

  void dispose() {
    nameController.removeListener(onChanged);
    amountController.removeListener(onChanged);
    nameController.dispose();
    amountController.dispose();
  }
}
