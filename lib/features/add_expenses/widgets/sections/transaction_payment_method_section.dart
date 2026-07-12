import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/setup_input_section.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/theme.dart';

enum PaymentMethod {
  applePay,
  cash,
  creditCard,
  debitCard,
  bankTransfer,
  other,
}

class TransactionPaymentMethodSection extends StatelessWidget {
  final String? selectedPaymentMethod;
  final ValueChanged<String?> onPaymentMethodChanged;

  const TransactionPaymentMethodSection({
    super.key,
    this.selectedPaymentMethod,
    required this.onPaymentMethodChanged,
  });

  static String paymentMethodToString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.applePay:
        return 'apple_pay';
      case PaymentMethod.cash:
        return 'cash';
      case PaymentMethod.creditCard:
        return 'credit_card';
      case PaymentMethod.debitCard:
        return 'debit_card';
      case PaymentMethod.bankTransfer:
        return 'bank_transfer';
      case PaymentMethod.other:
        return 'other';
    }
  }

  static PaymentMethod? stringToPaymentMethod(String? value) {
    if (value == null) return null;
    for (final method in PaymentMethod.values) {
      if (paymentMethodToString(method) == value) return method;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final currentMethod = stringToPaymentMethod(selectedPaymentMethod);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(AppLocalizations.of(context)!.paymentMethod),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: PaymentMethod.values.map((method) {
            final isSelected = method == currentMethod;
            return _PaymentMethodChip(
              method: method,
              isSelected: isSelected,
              onTap: () {
                onPaymentMethodChanged(isSelected ? null : paymentMethodToString(method));
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _PaymentMethodChip extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodChip({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  IconData _iconForMethod() {
    switch (method) {
      case PaymentMethod.applePay:
        return Icons.apple;
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.creditCard:
        return Icons.credit_card;
      case PaymentMethod.debitCard:
        return Icons.credit_card_outlined;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance;
      case PaymentMethod.other:
        return Icons.more_horiz;
    }
  }

  String _label(BuildContext context) {
    switch (method) {
      case PaymentMethod.applePay:
        return AppLocalizations.of(context)!.applePay;
      case PaymentMethod.cash:
        return AppLocalizations.of(context)!.cash;
      case PaymentMethod.creditCard:
        return AppLocalizations.of(context)!.creditCard;
      case PaymentMethod.debitCard:
        return AppLocalizations.of(context)!.debitCard;
      case PaymentMethod.bankTransfer:
        return AppLocalizations.of(context)!.bankTransfer;
      case PaymentMethod.other:
        return AppLocalizations.of(context)!.other;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = AppColors.accent(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : AppColors.surface(context),
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: selectedColor.withValues(alpha: 0.14),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _iconForMethod(),
                size: 16,
                color: isSelected ? Colors.white : AppColors.accent(context),
              ),
              const SizedBox(width: 8),
              Text(
                _label(context),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
