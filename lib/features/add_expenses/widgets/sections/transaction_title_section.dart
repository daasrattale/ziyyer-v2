import 'package:flutter/material.dart';
import 'package:ziyyer/l10n/app_localizations.dart';

class TransactionTitleSection extends StatelessWidget {
  const TransactionTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.addNewExpense, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
        SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.addNewExpenseSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
