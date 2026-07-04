import 'package:flutter/widgets.dart';

class BudgetOverviewWidget extends StatefulWidget {
  const BudgetOverviewWidget({super.key});

  @override
  State<BudgetOverviewWidget> createState() => _BudgetOverviewWidgetState();
}

class _BudgetOverviewWidgetState extends State<BudgetOverviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(child: const Text('BudgetOverviewWidget'));
  }
}
