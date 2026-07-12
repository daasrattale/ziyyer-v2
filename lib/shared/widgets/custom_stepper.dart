import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/theme.dart';

class CustomStepper extends StatelessWidget {
  final List<CustomStepperStep> steps;
  final int activeIndex;
  final VoidCallback goToNextStep;
  final VoidCallback goToPreviousStep;
  final VoidCallback goToDoneStep;
  final bool previousHidden;
  final double keyboardHeight;

  const CustomStepper({
    super.key,
    required this.steps,
    this.activeIndex = 0,
    required this.goToNextStep,
    required this.goToPreviousStep,
    required this.goToDoneStep,
    this.previousHidden = false,
    this.keyboardHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    final isLastStep = activeIndex == steps.length - 1;
    final isKeyboardOpen = keyboardHeight > 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          _StepperProgressBar(steps: steps, activeIndex: activeIndex),
          const SizedBox(height: 24),
          Expanded(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                reverseDuration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  final offsetAnimation = Tween<Offset>(
                    begin: const Offset(0.04, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: offsetAnimation, child: child),
                  );
                },
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(alignment: Alignment.topCenter, children: [...previousChildren, ?currentChild]);
                },
                child: KeyedSubtree(key: ValueKey(activeIndex), child: steps[activeIndex].content),
              ),
            ),
          ),
          if (!isKeyboardOpen)
            SafeArea(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                margin: EdgeInsets.only(bottom: bottomSafe + 6),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: Row(
                    key: ValueKey(activeIndex),
                    mainAxisAlignment: previousHidden ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                    children: [
                      if (!previousHidden) ...[
                        FilledButton.icon(
                          onPressed: goToPreviousStep,
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.surface(context),
                            foregroundColor: AppColors.textPrimary(context),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                          ),
                          icon: Icon(AppIcons.arrowLeft),
                          label: const Text('Previous'),
                        ),
                      ],

                      FilledButton.icon(
                        onPressed: isLastStep ? goToDoneStep : goToNextStep,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        ),
                        iconAlignment: IconAlignment.end,
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: Icon(isLastStep ? AppIcons.check : AppIcons.arrowRight, key: ValueKey(isLastStep)),
                        ),
                        label: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: Text(
                            isLastStep ? 'Done' : steps[activeIndex + 1].title,
                            key: ValueKey(isLastStep ? 'done' : steps[activeIndex + 1].title),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StepperProgressBar extends StatelessWidget {
  final List<CustomStepperStep> steps;
  final int activeIndex;

  const _StepperProgressBar({required this.steps, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isCompleted = index < activeIndex;
        final isActive = index == activeIndex;
        final color = step.color ?? Theme.of(context).primaryColor;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == steps.length - 1 ? 0 : 8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: isCompleted || isActive ? 1 : 0),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) {
                return Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.textHint(context).withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}

class CustomStepperStep {
  final String title;
  final Widget content;
  final Color? color;

  const CustomStepperStep({required this.content, this.color, required this.title});
}
