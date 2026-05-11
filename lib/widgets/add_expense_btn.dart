import 'package:flutter/material.dart';
import 'package:ziyyer/config/theme.dart';
import 'package:ziyyer/constants/app_icons.dart';

class AddExpenseButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AddExpenseButton({super.key, required this.onPressed});

  @override
  State<AddExpenseButton> createState() => _AddExpenseButtonState();
}

class _AddExpenseButtonState extends State<AddExpenseButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    final pulseCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(pulseCurve);
    _opacityAnimation = Tween<double>(begin: 0.8, end: 0.0).animate(pulseCurve);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        FadeTransition(
          opacity: _opacityAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accentColor(context),
                  width: 1, // Thickness of the pulse ring
                ),
              ),
            ),
          ),
        ),

        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accentColor(context),
            boxShadow: [BoxShadow(color: AppColors.accentColor(context).withAlpha(30), blurRadius: 16, spreadRadius: 4, offset: const Offset(0, 4))],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: widget.onPressed,
              child: const Center(child: Icon(AppIcons.add, color: Colors.white, size: 25)),
            ),
          ),
        ),
      ],
    );
  }
}
