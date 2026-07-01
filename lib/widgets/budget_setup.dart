import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/theme.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

enum BudgetSetupPeriod { weekly, monthly, yearly }

class BudgetSetupCategory {
  BudgetSetupCategory({
    required this.key,
    required this.name,
    required this.label,
    required this.description,
    required this.icon,
    this.selected = false,
    this.amount = 0,
  });

  final String key;
  final String name;
  final String label;
  final String description;
  final IconData icon;
  final bool selected;
  final double amount;

  BudgetSetupCategory copyWith({String? key, String? name, String? label, String? description, IconData? icon, bool? selected, double? amount}) {
    return BudgetSetupCategory(
      key: key ?? this.key,
      name: name ?? this.name,
      label: label ?? this.label,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      selected: selected ?? this.selected,
      amount: amount ?? this.amount,
    );
  }
}

class BudgetSetupResult {
  const BudgetSetupResult({required this.totalAmount, required this.currency, required this.period, required this.categories});

  final double totalAmount;
  final String currency;
  final BudgetSetupPeriod period;
  final List<BudgetSetupCategory> categories;
}

// ─── Step metadata ────────────────────────────────────────────────────────────

class _StepMeta {
  const _StepMeta({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

// ─── Main Widget ──────────────────────────────────────────────────────────────

class BudgetSetup extends StatefulWidget {
  const BudgetSetup({
    super.key,
    this.initialAmount = 3000,
    this.initialCurrency = 'EUR',
    this.initialPeriod = BudgetSetupPeriod.monthly,
    required this.onClose,
    required this.onSubmit,
  });

  final double initialAmount;
  final String initialCurrency;
  final BudgetSetupPeriod initialPeriod;
  final VoidCallback onClose;
  final ValueChanged<BudgetSetupResult> onSubmit;

  @override
  State<BudgetSetup> createState() => _BudgetSetupState();
}

class _BudgetSetupState extends State<BudgetSetup> with SingleTickerProviderStateMixin {
  static const int _totalSteps = 5;
  final List<String> _currencies = const ['EUR', 'USD', 'GBP', 'MAD', 'CAD', 'JPY'];

  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();
  final Map<String, TextEditingController> _allocationControllers = {};
  final ScrollController _scrollController = ScrollController();

  late AnimationController _progressAnimController;
  late Animation<double> _progressAnim;

  int _currentStep = 0;
  late String _selectedCurrency;
  late BudgetSetupPeriod _selectedPeriod;
  late List<BudgetSetupCategory> _categories;

  static const _stepMeta = [
    _StepMeta(icon: Icons.account_balance_wallet_outlined, label: 'Total'),
    _StepMeta(icon: Icons.calendar_month_outlined, label: 'Period'),
    _StepMeta(icon: Icons.checklist_rounded, label: 'Categories'),
    _StepMeta(icon: Icons.tune_rounded, label: 'Allocate'),
    _StepMeta(icon: Icons.check_circle_outline_rounded, label: 'Review'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.initialCurrency;
    _selectedPeriod = widget.initialPeriod;
    _amountController.text = widget.initialAmount.toStringAsFixed(0);

    _progressAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _progressAnim = Tween<double>(
      begin: 1 / _totalSteps,
      end: 1 / _totalSteps,
    ).animate(CurvedAnimation(parent: _progressAnimController, curve: Curves.easeInOut));

    _categories = [
      BudgetSetupCategory(
        key: 'housing',
        name: 'Housing',
        label: 'Housing',
        description: 'Rent, mortgage & home essentials',
        icon: Icons.apartment_rounded,
        selected: true,
      ),
      BudgetSetupCategory(
        key: 'food_dining',
        name: 'Food & Dining',
        label: 'Food & Dining',
        description: 'Groceries, restaurants & delivery',
        icon: Icons.restaurant_outlined,
        selected: true,
      ),
      BudgetSetupCategory(
        key: 'transport',
        name: 'Transport',
        label: 'Transport',
        description: 'Fuel, transit & vehicle costs',
        icon: Icons.directions_car_outlined,
        selected: true,
      ),
      BudgetSetupCategory(
        key: 'shopping',
        name: 'Shopping',
        label: 'Shopping',
        description: 'Clothes, gear & personal items',
        icon: Icons.shopping_bag_outlined,
        selected: true,
      ),
      BudgetSetupCategory(
        key: 'entertainment',
        name: 'Entertainment',
        label: 'Fun',
        description: 'Movies, games & subscriptions',
        icon: Icons.movie_outlined,
      ),
      BudgetSetupCategory(key: 'bills', name: 'Bills', label: 'Bills', description: 'Utilities, internet & phone', icon: Icons.bolt_outlined),
      BudgetSetupCategory(key: 'coffee', name: 'Coffee', label: 'Coffee', description: 'Cafes & quick drink stops', icon: Icons.local_cafe_outlined),
      BudgetSetupCategory(key: 'health', name: 'Health', label: 'Health', description: 'Pharmacy, fitness & wellness', icon: Icons.favorite_border),
    ];

    for (final cat in _categories) {
      _allocationControllers[cat.key] = TextEditingController(text: cat.amount.toStringAsFixed(0));
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    _progressAnimController.dispose();
    _scrollController.dispose();
    for (final c in _allocationControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  double get _totalAmount => double.tryParse(_amountController.text) ?? 0;
  List<BudgetSetupCategory> get _selectedCategories => _categories.where((c) => c.selected).toList();
  double get _allocatedAmount => _selectedCategories.fold(0, (sum, c) => sum + c.amount);
  double get _remainingAmount => _totalAmount - _allocatedAmount;
  double get _allocatedRatio => _totalAmount <= 0 ? 0 : (_allocatedAmount / _totalAmount).clamp(0.0, 1.0);

  bool get _canContinue {
    switch (_currentStep) {
      case 0:
        return _totalAmount > 0;
      case 1:
        return true;
      case 2:
        return _selectedCategories.isNotEmpty;
      case 3:
        return _selectedCategories.isNotEmpty && _allocatedAmount <= _totalAmount;
      case 4:
        return _selectedCategories.isNotEmpty;
      default:
        return false;
    }
  }

  String _formatCurrency(double value) {
    final fmt = NumberFormat.currency(locale: 'en', name: _selectedCurrency, decimalDigits: 0);
    return fmt.format(value);
  }

  void _animateProgress(int newStep) {
    _progressAnim = Tween<double>(
      begin: (_currentStep + 1) / _totalSteps,
      end: (newStep + 1) / _totalSteps,
    ).animate(CurvedAnimation(parent: _progressAnimController, curve: Curves.easeInOut));
    _progressAnimController
      ..reset()
      ..forward();
  }

  void _goNext() {
    if (!_canContinue) return;
    if (_currentStep == _totalSteps - 1) {
      widget.onSubmit(
        BudgetSetupResult(totalAmount: _totalAmount, currency: _selectedCurrency, period: _selectedPeriod, categories: _selectedCategories),
      );
      return;
    }
    _animateProgress(_currentStep + 1);
    setState(() => _currentStep++);
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void _goBack() {
    if (_currentStep == 0) {
      widget.onClose();
      return;
    }
    _animateProgress(_currentStep - 1);
    setState(() => _currentStep--);
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void _toggleCategory(String key) {
    setState(() {
      final i = _categories.indexWhere((c) => c.key == key);
      if (i == -1) return;
      final cur = _categories[i];
      final toggled = !cur.selected;
      _categories[i] = cur.copyWith(selected: toggled, amount: toggled ? cur.amount : 0);
      _allocationControllers[key]?.text = _categories[i].amount.toStringAsFixed(0);
    });
  }

  void _updateCategoryAmount(String key, String value) {
    final parsed = double.tryParse(value) ?? 0;
    setState(() {
      final i = _categories.indexWhere((c) => c.key == key);
      if (i == -1) return;
      _categories[i] = _categories[i].copyWith(amount: parsed);
    });
  }

  void _splitEvenly() {
    final sel = _selectedCategories;
    if (sel.isEmpty || _totalAmount <= 0) return;
    final even = _totalAmount / sel.length;
    setState(() {
      _categories = _categories.map((c) => c.selected ? c.copyWith(amount: even) : c).toList();
      for (final c in _categories) {
        _allocationControllers[c.key]?.text = c.amount.toStringAsFixed(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = AppColors.accent(context);
    final bg = AppColors.background(context);
    final surface = AppColors.surface(context);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            _SetupHeader(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              stepMeta: _stepMeta,
              progressAnim: _progressAnim,
              onBack: _goBack,
              onClose: widget.onClose,
              accent: accent,
              surface: surface,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AppConstants.screenMargin,
                  AppConstants.spacingLarge,
                  AppConstants.screenMargin,
                  AppConstants.spacingExtraLarge,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(anim),
                      child: child,
                    ),
                  ),
                  child: KeyedSubtree(key: ValueKey(_currentStep), child: _buildStepContent(context, accent, isDark, surface)),
                ),
              ),
            ),
            _BottomCta(
              label: _currentStep == _totalSteps - 1 ? 'Save Budget' : 'Continue',
              enabled: _canContinue,
              isLast: _currentStep == _totalSteps - 1,
              onPressed: _goNext,
              accent: accent,
              surface: surface,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, Color accent, bool isDark, Color surface) {
    switch (_currentStep) {
      case 0:
        return _TotalStep(
          amountController: _amountController,
          amountFocusNode: _amountFocusNode,
          selectedAmount: _totalAmount,
          selectedCurrency: _selectedCurrency,
          currencies: _currencies,
          onCurrencyChanged: (v) => setState(() => _selectedCurrency = v),
          onQuickAmountSelected: (v) => setState(() => _amountController.text = v.toStringAsFixed(0)),
          formatCurrency: _formatCurrency,
          accent: accent,
        );
      case 1:
        return _PeriodStep(selectedPeriod: _selectedPeriod, onPeriodChanged: (p) => setState(() => _selectedPeriod = p), accent: accent);
      case 2:
        return _CategoriesStep(categories: _categories, onToggle: _toggleCategory, accent: accent);
      case 3:
        return _AllocateStep(
          totalAmount: _totalAmount,
          allocatedAmount: _allocatedAmount,
          remainingAmount: _remainingAmount,
          allocatedRatio: _allocatedRatio,
          categories: _selectedCategories,
          onSplitEvenly: _splitEvenly,
          onAmountChanged: _updateCategoryAmount,
          formatCurrency: _formatCurrency,
          currencyCode: _selectedCurrency,
          controllers: _allocationControllers,
          accent: accent,
        );
      case 4:
        return _ReviewStep(
          totalAmount: _totalAmount,
          allocatedAmount: _allocatedAmount,
          remainingAmount: _remainingAmount,
          period: _selectedPeriod,
          categories: _selectedCategories,
          formatCurrency: _formatCurrency,
          accent: accent,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _SetupHeader extends StatelessWidget {
  const _SetupHeader({
    required this.currentStep,
    required this.totalSteps,
    required this.stepMeta,
    required this.progressAnim,
    required this.onBack,
    required this.onClose,
    required this.accent,
    required this.surface,
  });

  final int currentStep;
  final int totalSteps;
  final List<_StepMeta> stepMeta;
  final Animation<double> progressAnim;
  final VoidCallback onBack;
  final VoidCallback onClose;
  final Color accent;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meta = stepMeta[currentStep];

    return Container(
      decoration: BoxDecoration(
        color: surface,
        border: Border(bottom: BorderSide(color: AppColors.divider(context))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                _NavIconButton(icon: Icons.chevron_left_rounded, onPressed: onBack),
                const Spacer(),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    meta.label.toUpperCase(),
                    key: ValueKey(currentStep),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.textSecondary(context),
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                _NavIconButton(icon: Icons.close_rounded, onPressed: onClose),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _StepProgress(currentStep: currentStep, totalSteps: totalSteps, stepMeta: stepMeta, progressAnim: progressAnim, accent: accent),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({
    required this.currentStep,
    required this.totalSteps,
    required this.stepMeta,
    required this.progressAnim,
    required this.accent,
  });

  final int currentStep;
  final int totalSteps;
  final List<_StepMeta> stepMeta;
  final Animation<double> progressAnim;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final inactive = AppColors.divider(context);
    final bg = AppColors.background(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenMargin),
          child: Row(
            children: List.generate(totalSteps * 2 - 1, (i) {
              if (i.isOdd) {
                final segIdx = i ~/ 2;
                final filled = segIdx < currentStep;
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(color: filled ? accent : inactive, borderRadius: BorderRadius.circular(99)),
                  ),
                );
              }
              final stepIdx = i ~/ 2;
              final done = stepIdx < currentStep;
              final active = stepIdx == currentStep;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: active ? 36 : 28,
                height: active ? 36 : 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? accent : (active ? accent.withValues(alpha: 0.12) : bg),
                  border: Border.all(color: (done || active) ? accent : inactive, width: active ? 2 : 1.5),
                ),
                child: Center(
                  child: done
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                      : Icon(stepMeta[stepIdx].icon, size: active ? 16 : 12, color: active ? accent : AppColors.textHint(context)),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.screenMargin),
          child: AnimatedBuilder(
            animation: progressAnim,
            builder: (context, child) => ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progressAnim.value,
                minHeight: 3,
                backgroundColor: AppColors.divider(context),
                valueColor: AlwaysStoppedAnimation(accent),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Bottom CTA ───────────────────────────────────────────────────────────────

class _BottomCta extends StatelessWidget {
  const _BottomCta({
    required this.label,
    required this.enabled,
    required this.isLast,
    required this.onPressed,
    required this.accent,
    required this.surface,
  });

  final String label;
  final bool enabled;
  final bool isLast;
  final VoidCallback onPressed;
  final Color accent;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppConstants.screenMargin,
        AppConstants.spacingSmall,
        AppConstants.screenMargin,
        AppConstants.spacingSmall + bottomPad,
      ),
      decoration: BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: AppColors.divider(context))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton(
          onPressed: enabled ? onPressed : null,
          style: FilledButton.styleFrom(
            backgroundColor: accent,
            disabledBackgroundColor: AppColors.divider(context),
            foregroundColor: Colors.white,
            disabledForegroundColor: AppColors.textHint(context),
            textStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.maxBorderRadius)),
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Text(label), const SizedBox(width: 6), Icon(isLast ? Icons.check_rounded : Icons.arrow_forward_rounded, size: 18)],
          ),
        ),
      ),
    );
  }
}

// ─── Shared: Step Hero ────────────────────────────────────────────────────────

class _StepHero extends StatelessWidget {
  const _StepHero({required this.icon, required this.title, required this.subtitle, required this.accent});

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(shape: BoxShape.circle, color: accent.withValues(alpha: 0.12)),
          child: Icon(icon, size: 28, color: accent),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary(context)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─── Section label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textHint(context), letterSpacing: 1.5, fontWeight: FontWeight.w600),
    );
  }
}

// ─── Step 1 — Total ───────────────────────────────────────────────────────────

class _TotalStep extends StatelessWidget {
  const _TotalStep({
    required this.amountController,
    required this.amountFocusNode,
    required this.selectedAmount,
    required this.selectedCurrency,
    required this.currencies,
    required this.onCurrencyChanged,
    required this.onQuickAmountSelected,
    required this.formatCurrency,
    required this.accent,
  });

  final TextEditingController amountController;
  final FocusNode amountFocusNode;
  final double selectedAmount;
  final String selectedCurrency;
  final List<String> currencies;
  final ValueChanged<String> onCurrencyChanged;
  final ValueChanged<double> onQuickAmountSelected;
  final String Function(double) formatCurrency;
  final Color accent;

  static const _quickValues = [1000.0, 2000.0, 3000.0, 5000.0, 8000.0, 10000.0];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = AppColors.card(context);
    final borderColor = AppColors.divider(context);
    final sw = MediaQuery.sizeOf(context).width;
    final amountFontSize = sw < 380 ? 44.0 : 52.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHero(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Set your limit',
          subtitle: 'How much are you planning to spend?',
          accent: accent,
        ),
        const SizedBox(height: 32),
        _SectionLabel('CURRENCY'),
        const SizedBox(height: 10),
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: currencies.length,
            separatorBuilder: (_, index) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final cur = currencies[i];
              final sel = cur == selectedCurrency;
              return GestureDetector(
                onTap: () => onCurrencyChanged(cur),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: sel ? accent : cardColor,
                    borderRadius: BorderRadius.circular(AppConstants.maxBorderRadius),
                    border: Border.all(color: sel ? accent : borderColor),
                  ),
                  child: Text(
                    cur,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: sel ? Colors.white : AppColors.textSecondary(context),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 28),
        _SectionLabel('AMOUNT'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                selectedCurrency,
                style: theme.textTheme.headlineMedium?.copyWith(color: AppColors.textSecondary(context), fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: amountController,
                  focusNode: amountFocusNode,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: amountFontSize,
                    color: AppColors.textPrimary(context),
                    letterSpacing: -1,
                    height: 1,
                    fontFamily: 'Inter',
                  ),
                  decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        _SectionLabel('QUICK SELECT'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _quickValues.map((v) {
            final sel = selectedAmount.roundToDouble() == v;
            return GestureDetector(
              onTap: () => onQuickAmountSelected(v),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: sel ? accent : cardColor,
                  borderRadius: BorderRadius.circular(AppConstants.maxBorderRadius),
                  border: Border.all(color: sel ? accent : borderColor),
                ),
                child: Text(
                  formatCurrency(v),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: sel ? Colors.white : AppColors.textSecondary(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─── Step 2 — Period ──────────────────────────────────────────────────────────

class _PeriodStep extends StatelessWidget {
  const _PeriodStep({required this.selectedPeriod, required this.onPeriodChanged, required this.accent});

  final BudgetSetupPeriod selectedPeriod;
  final ValueChanged<BudgetSetupPeriod> onPeriodChanged;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final periods = [
      (BudgetSetupPeriod.weekly, 'Weekly', 'Resets every Monday', Icons.view_week_outlined),
      (BudgetSetupPeriod.monthly, 'Monthly', 'Resets on the 1st of each month', Icons.calendar_month_outlined),
      (BudgetSetupPeriod.yearly, 'Yearly', 'Resets every January 1st', Icons.calendar_today_outlined),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHero(icon: Icons.calendar_month_outlined, title: 'Budget rhythm', subtitle: 'How often should your budget reset?', accent: accent),
        const SizedBox(height: 32),
        ...periods.map((p) {
          final (period, title, subtitle, icon) = p;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _PeriodTile(
              icon: icon,
              title: title,
              subtitle: subtitle,
              selected: selectedPeriod == period,
              accent: accent,
              onTap: () => onPeriodChanged(period),
            ),
          );
        }),
      ],
    );
  }
}

// ─── Step 3 — Categories ──────────────────────────────────────────────────────

class _CategoriesStep extends StatelessWidget {
  const _CategoriesStep({required this.categories, required this.onToggle, required this.accent});

  final List<BudgetSetupCategory> categories;
  final ValueChanged<String> onToggle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedCount = categories.where((c) => c.selected).length;
    final sw = MediaQuery.sizeOf(context).width;
    final crossCount = sw < 320 ? 2 : 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHero(icon: Icons.checklist_rounded, title: 'What you track', subtitle: 'Pick your spending categories.', accent: accent),
        const SizedBox(height: 20),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppConstants.maxBorderRadius)),
              child: Text(
                '$selectedCount selected',
                style: theme.textTheme.labelLarge?.copyWith(color: accent, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 8),
            Text('· tap to toggle', style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textHint(context))),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossCount,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (_, i) {
            final cat = categories[i];
            return _CategoryTile(category: cat, accent: accent, onTap: () => onToggle(cat.key));
          },
        ),
      ],
    );
  }
}

// ─── Step 4 — Allocate ────────────────────────────────────────────────────────

class _AllocateStep extends StatelessWidget {
  const _AllocateStep({
    required this.totalAmount,
    required this.allocatedAmount,
    required this.remainingAmount,
    required this.allocatedRatio,
    required this.categories,
    required this.onSplitEvenly,
    required this.onAmountChanged,
    required this.formatCurrency,
    required this.currencyCode,
    required this.controllers,
    required this.accent,
  });

  final double totalAmount;
  final double allocatedAmount;
  final double remainingAmount;
  final double allocatedRatio;
  final List<BudgetSetupCategory> categories;
  final VoidCallback onSplitEvenly;
  final void Function(String, String) onAmountChanged;
  final String Function(double) formatCurrency;
  final String currencyCode;
  final Map<String, TextEditingController> controllers;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHero(icon: Icons.tune_rounded, title: 'Allocate funds', subtitle: 'Decide how much each category gets.', accent: accent),
        const SizedBox(height: 24),
        _AllocationBanner(
          totalAmount: totalAmount,
          allocatedAmount: allocatedAmount,
          remainingAmount: remainingAmount,
          ratio: allocatedRatio,
          onSplitEvenly: onSplitEvenly,
          formatCurrency: formatCurrency,
          accent: accent,
        ),
        const SizedBox(height: 16),
        ...categories.map(
          (cat) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _AllocationRow(
              category: cat,
              controller: controllers[cat.key]!,
              onChanged: (v) => onAmountChanged(cat.key, v),
              currencyCode: currencyCode,
              accent: accent,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Step 5 — Review ──────────────────────────────────────────────────────────

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({
    required this.totalAmount,
    required this.allocatedAmount,
    required this.remainingAmount,
    required this.period,
    required this.categories,
    required this.formatCurrency,
    required this.accent,
  });

  final double totalAmount;
  final double allocatedAmount;
  final double remainingAmount;
  final BudgetSetupPeriod period;
  final List<BudgetSetupCategory> categories;
  final String Function(double) formatCurrency;
  final Color accent;

  String get _periodLabel {
    switch (period) {
      case BudgetSetupPeriod.weekly:
        return 'Weekly';
      case BudgetSetupPeriod.monthly:
        return 'Monthly';
      case BudgetSetupPeriod.yearly:
        return 'Yearly';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = AppColors.card(context);
    final borderColor = AppColors.divider(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHero(icon: Icons.check_circle_outline_rounded, title: 'Looking good!', subtitle: 'Review your budget before saving.', accent: accent),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [accent, Color.lerp(accent, AppColors.gradientEnd, 0.6)!],
            ),
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.25), blurRadius: 24, offset: const Offset(0, 8))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppConstants.maxBorderRadius),
                ),
                child: Text(
                  _periodLabel.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.white, letterSpacing: 1.5, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                formatCurrency(totalAmount),
                style: theme.textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 40,
                  letterSpacing: -1,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text('Total budget', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.75))),
              const SizedBox(height: 20),
              Row(
                children: [
                  _ReviewStat(label: 'ALLOCATED', value: formatCurrency(allocatedAmount)),
                  const SizedBox(width: AppConstants.spacingLarge),
                  _ReviewStat(label: 'FREE', value: formatCurrency(math.max(0, remainingAmount))),
                  const SizedBox(width: AppConstants.spacingLarge),
                  _ReviewStat(label: 'CATEGORIES', value: '${categories.length}'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _SectionLabel('BREAKDOWN'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            border: Border.all(color: borderColor),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (_, index) => Divider(height: 1, color: borderColor, indent: 64),
            itemBuilder: (_, i) {
              final cat = categories[i];
              return _ReviewRow(category: cat, formatCurrency: formatCurrency, accent: accent);
            },
          ),
        ),
      ],
    );
  }
}

// ─── Atoms ────────────────────────────────────────────────────────────────────

class _NavIconButton extends StatelessWidget {
  const _NavIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      color: AppColors.textPrimary(context),
      style: IconButton.styleFrom(backgroundColor: AppColors.card(context), shape: const CircleBorder(), padding: const EdgeInsets.all(8)),
    );
  }
}

class _PeriodTile extends StatelessWidget {
  const _PeriodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        decoration: BoxDecoration(
          color: selected ? accent.withValues(alpha: 0.07) : AppColors.card(context),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          border: Border.all(color: selected ? accent : AppColors.divider(context), width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(shape: BoxShape.circle, color: selected ? accent : AppColors.cardAlt(context)),
              child: Icon(icon, size: 20, color: selected ? Colors.white : AppColors.textSecondary(context)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary(context))),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? accent : Colors.transparent,
                border: Border.all(color: selected ? accent : AppColors.divider(context), width: 1.5),
              ),
              child: selected ? const Icon(Icons.check_rounded, color: Colors.white, size: 13) : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.accent, required this.onTap});

  final BudgetSetupCategory category;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = category.selected;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: selected ? accent : AppColors.card(context),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          border: Border.all(color: selected ? accent : AppColors.divider(context)),
          boxShadow: selected ? [BoxShadow(color: accent.withValues(alpha: 0.22), blurRadius: 12, offset: const Offset(0, 4))] : null,
        ),
        child: Stack(
          children: [
            if (selected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white24),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 11),
                ),
              ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(category.icon, size: 26, color: selected ? Colors.white : AppColors.textSecondary(context)),
                    const SizedBox(height: 8),
                    Text(
                      category.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: selected ? Colors.white : AppColors.textPrimary(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllocationBanner extends StatelessWidget {
  const _AllocationBanner({
    required this.totalAmount,
    required this.allocatedAmount,
    required this.remainingAmount,
    required this.ratio,
    required this.onSplitEvenly,
    required this.formatCurrency,
    required this.accent,
  });

  final double totalAmount;
  final double allocatedAmount;
  final double remainingAmount;
  final double ratio;
  final VoidCallback onSplitEvenly;
  final String Function(double) formatCurrency;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOver = remainingAmount < 0;
    final statusColor = isOver ? AppColors.expense : accent;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('REMAINING', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textHint(context), letterSpacing: 1.5)),
                    const SizedBox(height: 4),
                    Text(
                      formatCurrency(math.max(0, remainingAmount)),
                      style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700, color: statusColor, letterSpacing: -0.5),
                    ),
                    Text('of ${formatCurrency(totalAmount)}', style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary(context))),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: onSplitEvenly,
                style: OutlinedButton.styleFrom(
                  foregroundColor: accent,
                  side: BorderSide(color: accent.withValues(alpha: 0.4)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.maxBorderRadius)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  textStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.auto_awesome, size: 14), SizedBox(width: 6), Text('Split evenly')],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              backgroundColor: AppColors.divider(context),
              valueColor: AlwaysStoppedAnimation(isOver ? AppColors.expense : accent),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('${(ratio * 100).round()}% allocated', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.textHint(context))),
              if (isOver) ...[
                const SizedBox(width: 8),
                Text(
                  '· Over budget!',
                  style: theme.textTheme.labelSmall?.copyWith(color: AppColors.expense, fontWeight: FontWeight.w700),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _AllocationRow extends StatelessWidget {
  const _AllocationRow({required this.category, required this.controller, required this.onChanged, required this.currencyCode, required this.accent});

  final BudgetSetupCategory category;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String currencyCode;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sw = MediaQuery.sizeOf(context).width;
    final inputW = sw < 360 ? 110.0 : 130.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: AppColors.divider(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(shape: BoxShape.circle, color: accent.withValues(alpha: 0.10)),
            child: Icon(category.icon, size: 18, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.label, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                Text(category.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: inputW,
            height: 40,
            decoration: BoxDecoration(color: AppColors.cardAlt(context), borderRadius: BorderRadius.circular(AppConstants.maxBorderRadius)),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text(
                  currencyCode,
                  style: theme.textTheme.labelMedium?.copyWith(color: AppColors.textSecondary(context), fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    onChanged: onChanged,
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewStat extends StatelessWidget {
  const _ReviewStat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.6), letterSpacing: 1.2)),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.category, required this.formatCurrency, required this.accent});

  final BudgetSetupCategory category;
  final String Function(double) formatCurrency;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(shape: BoxShape.circle, color: accent.withValues(alpha: 0.10)),
            child: Icon(category.icon, size: 17, color: accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(category.label, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
          ),
          Text(
            formatCurrency(category.amount),
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary(context)),
          ),
        ],
      ),
    );
  }
}
