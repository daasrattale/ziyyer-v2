import 'package:flutter/material.dart';
import 'package:ziyyer/features/insights/widgets/insights_widget.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/config/app_icons.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/services/service_locator.dart';
import 'package:ziyyer/shared/ui/loader.dart';
import 'package:ziyyer/theme.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final _budgetService = ServiceLocator.budgetService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<BudgetModel?>(
        stream: _budgetService.watch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          if (!snapshot.hasData) {
            return _NoBudgetPlaceholder();
          }

          final budgetModel = snapshot.data!;

          if (!budgetModel.isSetup) {
            return _NoBudgetPlaceholder();
          }

          return InsightsWidget(budgetModel: budgetModel);
        },
      ),
    );
  }
}

class _NoBudgetPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcons.insights, size: 50, color: AppColors.accent(context)),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.noTransactionsYet,
            style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.noTransactionsSubtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
