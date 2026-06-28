import 'package:flutter/material.dart';
import 'package:ziyyer/constants/app_icons.dart';

import 'demo_screen.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoScreen(title: 'Add Expense Screen', iconData: AppIcons.add);
  }
}
