import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Your budget amount and currency', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
        SizedBox(height: 8),
        Text(
          'How much do you plan to spend in total? and in which currency?',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
