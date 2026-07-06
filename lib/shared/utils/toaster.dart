import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Toaster {
  static ToastificationItem success(String message) {
    return _toast(message, ToastificationType.success);
  }

  static ToastificationItem error(String message) {
    return _toast(message, ToastificationType.error);
  }

  static ToastificationItem warning(String message) {
    return _toast(message, ToastificationType.warning);
  }

  static ToastificationItem info(String message) {
    return _toast(message, ToastificationType.info);
  }

  static ToastificationItem _toast(String message, ToastificationType type) {
    return toastification.show(
      type: type,
      style: ToastificationStyle.fillColored,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }
}
