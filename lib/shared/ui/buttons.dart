import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;

class Buttons {
  // Primary button
  static Widget primaryButton({
    required String text,
    required VoidCallback onPressed,
    required BuildContext context,
    bool isLoading = false,
    Color? backgroundColor,
    Color? textColor,
    double? width,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  }) {
    return SizedBox(
      width: width,
      child: CupertinoButton.filled(
        padding: padding,
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(height: 20, width: 20, child: CupertinoActivityIndicator())
            : Text(text, style: DefaultTextStyle.of(context).style.copyWith(color: textColor)),
      ),
    );
  }

  // Secondary button
  static Widget secondaryButton({
    required String text,
    required VoidCallback onPressed,
    required BuildContext context,
    Color? borderColor,
    Color? textColor,
    double? width,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
  }) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: borderColor ?? Colors.grey[400]!),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(text, style: DefaultTextStyle.of(context).style.copyWith(color: textColor)),
        ),
      ),
    );
  }

  // Text button
  static Widget textButton({
    required String text,
    required VoidCallback onPressed,
    required BuildContext context,
    Color? textColor,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  }) {
    return CupertinoButton(
      padding: padding,
      onPressed: onPressed,
      child: Text(text, style: DefaultTextStyle.of(context).style.copyWith(color: textColor)),
    );
  }

  // Icon button
  static Widget iconButton({required IconData icon, required VoidCallback onPressed, String? tooltip, Color? backgroundColor, Color? iconColor}) {
    return CupertinoButton(
      padding: const EdgeInsets.all(8),
      onPressed: onPressed,
      child: Icon(icon, color: iconColor),
    );
  }

  // Floating action button
  static Widget fab({required IconData icon, required VoidCallback onPressed, String? tooltip, Color? backgroundColor}) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(32),
      color: backgroundColor,
      child: Icon(icon),
    );
  }
}
