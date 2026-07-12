import 'package:flutter/material.dart';
import 'package:ziyyer/l10n/app_localizations.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.budgetAmountAndCurrency, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
        SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.budgetAmountSubtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
