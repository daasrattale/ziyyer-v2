import 'package:flutter/material.dart';
import 'package:ziyyer/features/settings/widgets/settings_widget.dart';
import 'package:ziyyer/shared/services/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  final LocaleProvider localeProvider;

  const SettingsScreen({super.key, required this.localeProvider});

  @override
  Widget build(BuildContext context) {
    return SettingsWidget(localeProvider: localeProvider);
  }
}
