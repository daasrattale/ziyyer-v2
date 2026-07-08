import 'package:flutter/material.dart';
import 'package:ziyyer/theme.dart';

class TransactionAmountSection extends StatelessWidget {
  final TextEditingController amountController;
  final String currencySymbol;

  const TransactionAmountSection({super.key, required this.amountController, required this.currencySymbol});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          'AMOUNT',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 2.2,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                currencySymbol,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1,
                ),
              ),
              const SizedBox(width: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 140, maxWidth: 220),
                child: TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  cursorColor: theme.colorScheme.primary,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 64,
                    height: 1,
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    isDense: true,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.zero,
                    hintStyle: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 64,
                      height: 1,
                      color: AppColors.textHint(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
