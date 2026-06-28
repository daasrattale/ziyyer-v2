import 'package:flutter/material.dart';
import 'package:ziyyer/model/budget_setup_result.dart';
import 'package:ziyyer/model/category_setup_result.dart';
import 'package:ziyyer/services/service_locator.dart';

class BudgetSetup extends StatefulWidget {
  const BudgetSetup({super.key});

  @override
  State<BudgetSetup> createState() => _BudgetSetupState();
}

class _BudgetSetupState extends State<BudgetSetup> {
  final _budgetFormKey = GlobalKey<FormState>();
  final _allocationFormKey = GlobalKey<FormState>();

  int _currentStep = 0;

  final _budgetAmountController = TextEditingController();
  final _newCategoryController = TextEditingController();

  String _currency = 'EUR';

  final List<String> _categories = [];
  final Map<String, TextEditingController> _categoryAmountControllers = {};

  @override
  void dispose() {
    _budgetAmountController.dispose();
    _newCategoryController.dispose();
    for (final controller in _categoryAmountControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  double get _budgetDefinedAmount =>
      double.tryParse(_budgetAmountController.text.trim()) ?? 0;

  double get _categoriesDefinedTotal {
    return _categoryAmountControllers.values.fold(
      0.0,
      (sum, controller) => sum + (double.tryParse(controller.text.trim()) ?? 0),
    );
  }

  double get _remainingAmount => _budgetDefinedAmount - _categoriesDefinedTotal;

  void _addCategory() {
    final name = _newCategoryController.text.trim();
    if (name.isEmpty || _categories.contains(name)) return;

    setState(() {
      _categories.add(name);
      _categoryAmountControllers[name] = TextEditingController();
      _newCategoryController.clear();
    });
  }

  void _removeCategory(String name) {
    setState(() {
      _categories.remove(name);
      _categoryAmountControllers.remove(name)?.dispose();
    });
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0) {
      return _budgetFormKey.currentState?.validate() ?? false;
    }

    if (_currentStep == 1) {
      if (_categories.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one category')),
        );
        return false;
      }
      return true;
    }

    if (_currentStep == 2) {
      final valid = _allocationFormKey.currentState?.validate() ?? false;
      if (!valid) return false;

      if (_categoriesDefinedTotal > _budgetDefinedAmount) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category amounts cannot exceed total budget amount'),
          ),
        );
        return false;
      }
      return true;
    }

    return true;
  }

  void _continue() {
    if (!_validateCurrentStep()) return;

    if (_currentStep == 2) {
      final result = BudgetSetupResult(
        definedAmount: _budgetDefinedAmount,
        currency: _currency,
        categories: _categories.map((name) {
          return CategorySetupResult(
            name: name,
            definedAmount:
                double.tryParse(
                  _categoryAmountControllers[name]?.text.trim() ?? '',
                ) ??
                0,
          );
        }).toList(),
      );

      ServiceLocator.budgetService.createBudgetWithCategories(result);

      return;
    }

    setState(() {
      _currentStep += 1;
    });
  }

  void _back() {
    if (_currentStep == 0) return;
    setState(() {
      _currentStep -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastStep = _currentStep == 2;

    return Column(
      children: [
        Stepper(
          currentStep: _currentStep,
          controlsBuilder: (_, __) => const SizedBox.shrink(),
          onStepTapped: (index) {
            if (index <= _currentStep) {
              setState(() => _currentStep = index);
            }
          },
          steps: [
            Step(
              title: const Text('Budget'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Form(
                key: _budgetFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _budgetAmountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Total defined amount',
                        hintText: '3000',
                        prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                      ),
                      validator: (value) {
                        final parsed = double.tryParse(value?.trim() ?? '');
                        if (parsed == null || parsed <= 0) {
                          return 'Enter a valid budget amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _currency,
                      decoration: const InputDecoration(
                        labelText: 'Currency',
                        prefixIcon: Icon(Icons.currency_exchange),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                        DropdownMenuItem(value: 'USD', child: Text('USD')),
                        DropdownMenuItem(value: 'GBP', child: Text('GBP')),
                        DropdownMenuItem(value: 'MAD', child: Text('MAD')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _currency = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Step(
              title: const Text('Categories'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _newCategoryController,
                          decoration: const InputDecoration(
                            labelText: 'Category name',
                            hintText: 'Food',
                          ),
                          onSubmitted: (_) => _addCategory(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton.filled(
                        onPressed: _addCategory,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_categories.isEmpty)
                    Text(
                      'No categories added yet',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  if (_categories.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((name) {
                        return Chip(
                          label: Text(name),
                          onDeleted: () => _removeCategory(name),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
            Step(
              title: const Text('Defined amounts'),
              isActive: _currentStep >= 2,
              state: StepState.indexed,
              content: Form(
                key: _allocationFormKey,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _AmountSummaryRow(
                            label: 'Budget total',
                            amount: _budgetDefinedAmount,
                            currency: _currency,
                          ),
                          const SizedBox(height: 8),
                          _AmountSummaryRow(
                            label: 'Categories total',
                            amount: _categoriesDefinedTotal,
                            currency: _currency,
                          ),
                          const SizedBox(height: 8),
                          _AmountSummaryRow(
                            label: 'Remaining',
                            amount: _remainingAmount,
                            currency: _currency,
                            amountColor: _remainingAmount < 0
                                ? theme.colorScheme.error
                                : theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._categories.map((name) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextFormField(
                          controller: _categoryAmountControllers[name],
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            labelText: '$name defined amount',
                            prefixText: '$_currency ',
                          ),
                          validator: (value) {
                            final parsed = double.tryParse(value?.trim() ?? '');
                            if (parsed == null || parsed < 0) {
                              return 'Enter a valid amount';
                            }
                            return null;
                          },
                          onChanged: (_) => setState(() {}),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _currentStep == 0 ? null : _back,
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: _continue,
                child: Text(isLastStep ? 'Save setup' : 'Continue'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AmountSummaryRow extends StatelessWidget {
  const _AmountSummaryRow({
    required this.label,
    required this.amount,
    required this.currency,
    this.amountColor,
  });

  final String label;
  final double amount;
  final String currency;
  final Color? amountColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(child: Text(label, style: textTheme.titleMedium)),
        Text(
          '$currency ${amount.toStringAsFixed(2)}',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: amountColor,
          ),
        ),
      ],
    );
  }
}
