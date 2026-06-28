import 'package:flutter/material.dart';
import 'package:ziyyer/constants/app_icons.dart';

import 'demo_screen.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScreen(title: 'Insights Screen', iconData: AppIcons.insights);
  }
}

