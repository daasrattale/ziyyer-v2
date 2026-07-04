import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/theme.dart';

class CustomStepper extends StatefulWidget {
  final List<CustomStepperStep> steps;
  final int initialActiveIndex;
  final VoidCallback goToNextStep;
  final VoidCallback goToPreviousStep;
  const CustomStepper({super.key, required this.steps, this.initialActiveIndex = 0, required this.goToNextStep, required this.goToPreviousStep});
  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.steps.asMap().entries.map((entry) {
              int index = entry.key;
              CustomStepperStep step = entry.value;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Step Circle
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    // width: 38,
                    // height: 38,
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                      color: index <= widget.initialActiveIndex ? step.color ?? Theme.of(context).primaryColor : AppColors.surface(context),
                    ),
                    child: Center(
                      child: Text(
                        step.title,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: index <= widget.initialActiveIndex ? step.color ?? Colors.white : AppColors.textHint(context),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          widget.steps[widget.initialActiveIndex].content,
          const SizedBox(height: 32),
          // Navigation Buttons
          Row(
            mainAxisAlignment: widget.initialActiveIndex > 0 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
            children: [
              if (widget.initialActiveIndex > 0) ...[
                ElevatedButton(onPressed: widget.initialActiveIndex > 0 ? widget.goToPreviousStep : null, child: const Text("Back")),
              ],
              ElevatedButton(onPressed: widget.initialActiveIndex < widget.steps.length - 1 ? widget.goToNextStep : null, child: const Text("Next")),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomStepperStep {
  final String title;
  final Widget content;
  final Color? color;

  CustomStepperStep({required this.content, this.color, required this.title});
}
