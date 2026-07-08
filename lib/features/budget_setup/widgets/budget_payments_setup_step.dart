import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/models/payement_model.dart';
import 'package:ziyyer/theme.dart';

class BudgetPaymentsSetupStep extends StatefulWidget {
  final Function(List<PaymentModel> payments) onPaymentsChanged;
  final BudgetModel budgetModel;

  const BudgetPaymentsSetupStep({super.key, required this.onPaymentsChanged, required this.budgetModel});

  @override
  State<BudgetPaymentsSetupStep> createState() => _BudgetPaymentsSetupStepState();
}

class _BudgetPaymentsSetupStepState extends State<BudgetPaymentsSetupStep> {
  final List<_PaymentRowData> _rows = [];

  @override
  void initState() {
    super.initState();

    final existingPayments = widget.budgetModel.payments;

    if (existingPayments.isNotEmpty) {
      _rows.addAll(
        existingPayments.map(
          (payment) => _PaymentRowData(
            onChanged: _handleRowChanged,
            initialName: payment.name,
            initialAmount: _amountToText(payment.amount),
          ),
        ),
      );
    } else {
      _rows.add(_PaymentRowData(onChanged: _handleRowChanged));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _notifyParent();
    });
  }

  static String _amountToText(double value) {
    if (value == 0) return '';
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  @override
  void dispose() {
    for (final row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  void _handleRowChanged() {
    setState(() {});
    _notifyParent();
  }

  void _addEmptyRow() {
    setState(() {
      _rows.add(_PaymentRowData(onChanged: _handleRowChanged));
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
    final payments = _rows
        .map(
          (row) => PaymentModel(
            id: null,
            name: row.nameController.text.trim(),
            amount: double.tryParse(row.amountController.text.trim().replaceAll(',', '.')) ?? 0.0,
          ),
        )
        .where((payment) => payment.name.isNotEmpty || payment.amount > 0)
        .toList();

    widget.onPaymentsChanged(payments);
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
          'Recurring payments',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: AppColors.textPrimary(context)),
        ),
        const SizedBox(height: 8),
        Text(
          'Add recurring bills like rent or subscriptions.',
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
                  label: 'TOTAL PAYMENTS',
                  value: _formatAmount(widget.budgetModel.allocatedPayementsAmount),
                  alignment: CrossAxisAlignment.start,
                ),
              ),
              Expanded(
                child: _SummaryValue(
                  label: 'LEFT TO ALLOCATE',
                  value: _formatAmount(widget.budgetModel.definedAmount - widget.budgetModel.allocatedPayementsAmount),
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
                        child: Icon(AppIcons.receipt, color: AppColors.textHint(context), size: 18),
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
                            hintText: 'e.g. Netflix',
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
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary(context),
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
                  'Add another payment',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textSecondary(context)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Optional · skip if you have no recurring bills',
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

class _PaymentRowData {
  final VoidCallback onChanged;

  final TextEditingController nameController;
  final TextEditingController amountController;

  _PaymentRowData({required this.onChanged, String initialName = '', String initialAmount = ''})
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
