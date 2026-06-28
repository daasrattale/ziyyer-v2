import 'package:ziyyer/services/budget_service.dart';

import '../database/database.dart';
import 'category_service.dart';

class ServiceLocator {
  static late BudgetService _budgetService;
  static late CategoryService _categoryService;

  static void initialize(AppDatabase db) {
    _budgetService = BudgetService(db);
    _categoryService = CategoryService(db);
  }

  // SINGLETON ACCESSORS
  static BudgetService get budgetService => _budgetService;

  static CategoryService get categoryService => _categoryService;
}
