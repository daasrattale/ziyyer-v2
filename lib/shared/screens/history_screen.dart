import 'package:flutter/material.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/config/app_icons.dart';

import 'demo_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScreen(title: AppLocalizations.of(context)!.historyScreen, iconData: AppIcons.history);
  }
}
