import 'package:flutter/material.dart';
import 'package:ziyyer/theme.dart';

class StepsSection extends StatefulWidget {
  const StepsSection({super.key});

  @override
  State<StepsSection> createState() => _StepsSectionState();
}

class _StepsSectionState extends State<StepsSection> {
  @override
  Widget build(BuildContext context) {
    const double circleSize = 32;
    int stepIndex = 0;
    final int totalSteps = 3;

    return Column(
      children: [
        SizedBox(
          height: circleSize,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(totalSteps, (i) {
              final isActive = i == stepIndex;
              return Container(
                width: circleSize,
                height: circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? Colors.white : AppColors.surface(context),
                  border: Border.all(color: isActive ? Theme.of(context).primaryColor : AppColors.surface(context), width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Theme.of(context).primaryColor : AppColors.textHint(context),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
