import 'package:flutter/material.dart';

class TransactionTitleSection extends StatelessWidget {
  const TransactionTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Add a new expense', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
        SizedBox(height: 8),
        Text(
          'Track a new transaction and assign it to a category.?',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
