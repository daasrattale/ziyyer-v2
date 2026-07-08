import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/theme.dart';

class SetupFieldContainer extends StatelessWidget {
  final Widget child;

  const SetupFieldContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.defaultBorderRadius)),
      ),
      child: child,
    );
  }
}

InputDecoration buildSetupInputDecoration({
  required String hintText,
  required IconData icon,
  required BuildContext context,
}) {
  return InputDecoration(
    hintText: hintText,
    isDense: true,
    isCollapsed: true,
    filled: false,
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    prefixIcon: Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
    ),
    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
    hintStyle: Theme.of(
      context,
    ).textTheme.bodyLarge?.copyWith(color: AppColors.textHint(context), fontWeight: FontWeight.w500, height: 1),
    contentPadding: EdgeInsets.zero,
  );
}

class SectionLabel extends StatelessWidget {
  final String title;

  const SectionLabel(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700));
  }
}
