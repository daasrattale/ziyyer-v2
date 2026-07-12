import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/theme.dart';

class AddExpenseButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AddExpenseButton({super.key, required this.onPressed});

  @override
  State<AddExpenseButton> createState() => _AddExpenseButtonState();
}

class _AddExpenseButtonState extends State<AddExpenseButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
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
        Container(
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

        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.accentColor(context),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentColor(context).withAlpha(30),
                blurRadius: 16,
                spreadRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
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
