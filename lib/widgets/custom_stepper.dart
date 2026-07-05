import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/theme.dart';

class CustomStepper extends StatefulWidget {
  final List<CustomStepperStep> steps;
  final int initialActiveIndex;
  final VoidCallback goToNextStep;
  final VoidCallback goToPreviousStep;
  final VoidCallback goToDoneStep;
  const CustomStepper({
    super.key,
    required this.steps,
    this.initialActiveIndex = 0,
    required this.goToNextStep,
    required this.goToPreviousStep,
    required this.goToDoneStep,
  });
  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Step Circle
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    width: (screenWidth / widget.steps.length) - (screenWidth * 0.05),
                    height: 8,
                    decoration: BoxDecoration(
                      color: index <= widget.initialActiveIndex
                          ? step.color ?? Theme.of(context).primaryColor
                          : AppColors.textHint(context),
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
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
                ElevatedButton(
                  onPressed: widget.initialActiveIndex > 0 ? widget.goToPreviousStep : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface(context),
                    foregroundColor: AppColors.textPrimary(context),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 4,
                    children: [Icon(AppIcons.arrowLeft), Text("Previous")],
                  ),
                ),
              ],
              if (widget.initialActiveIndex < widget.steps.length - 1) ...[
                ElevatedButton(
                  onPressed: widget.goToNextStep,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 4,
                    children: [Text(widget.steps[widget.initialActiveIndex + 1].title), Icon(AppIcons.arrowRight)],
                  ),
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: widget.goToDoneStep,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 4,
                    children: [Text("Done"), Icon(AppIcons.check)],
                  ),
                ),
              ],
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
