import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ziyyer/shared/extensions/string_extensions.dart';

extension DateTimeX on DateTime {
  String prettyDate([BuildContext? context]) {
    final locale = context != null ? Localizations.localeOf(context).languageCode : 'en';
    return DateFormat('E d MMMM y', locale).format(this).capitalizeFirst();
  }

  String prettyDateTime([BuildContext? context]) {
    final locale = context != null ? Localizations.localeOf(context).languageCode : 'en';
    return DateFormat('E d MMMM y, HH:mm', locale).format(this).capitalizeFirst();
  }

  String monthAndYear([BuildContext? context]) {
    final locale = context != null ? Localizations.localeOf(context).languageCode : 'en';
    return DateFormat('MMMM y', locale).format(this);
  }

  String fullDateTime([BuildContext? context]) {
    final locale = context != null ? Localizations.localeOf(context).languageCode : 'en';
    return DateFormat('E d MMMM y HH:mm', locale).format(this);
  }
}
