import 'package:flutter/material.dart';

class Buttons {
  // Primary button
  static Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    Color? backgroundColor,
    Color? textColor,
    double? width,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: backgroundColor, disabledBackgroundColor: Colors.grey[300], padding: padding),
      child: isLoading
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : Text(text, style: TextStyle(color: textColor)),
    );
  }

  // Secondary button
  static Widget secondaryButton({
    required String text,
    required VoidCallback onPressed,
    Color? borderColor,
    Color? textColor,
    double? width,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor ?? Colors.grey[400]!),
        padding: padding,
      ),
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }

  // Text button
  static Widget textButton({
    required String text,
    required VoidCallback onPressed,
    Color? textColor,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(padding: padding),
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }

  // Icon button
  static Widget iconButton({required IconData icon, required VoidCallback onPressed, String? tooltip, Color? backgroundColor, Color? iconColor}) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      tooltip: tooltip,
      color: iconColor,
      style: IconButton.styleFrom(backgroundColor: backgroundColor),
    );
  }

  // Floating action button
  static Widget fab({required IconData icon, required VoidCallback onPressed, String? tooltip, Color? backgroundColor}) {
    return FloatingActionButton(onPressed: onPressed, tooltip: tooltip, backgroundColor: backgroundColor, child: Icon(icon));
  }
}
