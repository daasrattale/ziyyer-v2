import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/screens/demo_screen.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScreen(title: 'Budget Screen', iconData: AppIcons.budget);
  }
}
