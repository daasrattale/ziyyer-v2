import 'package:flutter/material.dart';
import 'package:ziyyer/features/settings/widgets/language_widget.dart';
import 'package:ziyyer/shared/services/locale_provider.dart';

class LanguageScreen extends StatelessWidget {
  final LocaleProvider localeProvider;

  const LanguageScreen({super.key, required this.localeProvider});

  @override
  Widget build(BuildContext context) {
    return LanguageWidget(localeProvider: localeProvider);
  }
}
