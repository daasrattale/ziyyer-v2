import 'package:flutter/material.dart';
import 'package:ziyyer/features/add_expenses/widgets/sections/setup_input_section.dart';

class TransactionAmountSection extends StatelessWidget {
  final TextEditingController amountController;

  const TransactionAmountSection({super.key, required this.amountController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('Amount'),
        const SizedBox(height: 12),
        SetupFieldContainer(
          child: SizedBox(
            height: 56,
            child: Center(
              child: TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlignVertical: TextAlignVertical.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, height: 1),
                decoration: buildSetupInputDecoration(
                  hintText: 'e.g. 120',
                  icon: Icons.payments_outlined,
                  context: context,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
