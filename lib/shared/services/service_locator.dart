import 'package:ziyyer/shared/services/budget_service.dart';

import 'category_service.dart';

class ServiceLocator {
  static late BudgetService _budgetService;
  static late CategoryService _categoryService;

  static void initialize() {
    _budgetService = BudgetService();
    _categoryService = CategoryService();
  }

  // SINGLETON ACCESSORS
  static BudgetService get budgetService => _budgetService;
  static CategoryService get categoryService => _categoryService;
}
