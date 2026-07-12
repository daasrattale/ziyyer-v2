import 'package:flutter/material.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/config/app_icons.dart';

import 'demo_screen.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScreen(title: AppLocalizations.of(context)!.insightsScreen, iconData: AppIcons.insights);
  }
}
