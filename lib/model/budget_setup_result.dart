import 'category_setup_result.dart';

class BudgetSetupResult {
  const BudgetSetupResult({
    required this.definedAmount,
    required this.currency,
    required this.categories,
  });

  final double definedAmount;
  final String currency;
  final List<CategorySetupResult> categories;
}