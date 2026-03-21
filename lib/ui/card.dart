import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final double borderRadius;
  final BoxBorder? border;
  final BoxShadow? shadow;
  final VoidCallback? onTap;

  const CustomCard({
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 12,
    this.border,
    this.shadow,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border ?? Border.all(color: theme.dividerColor, width: 1),
          boxShadow: shadow != null ? [shadow!] : null,
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
