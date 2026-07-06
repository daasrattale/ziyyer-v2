import 'package:ziyyer/shared/services/budget_service.dart';
import 'package:ziyyer/shared/services/payment_service.dart';

import 'category_service.dart';

class ServiceLocator {
  static late BudgetService _budgetService;
  static late CategoryService _categoryService;
  static late PaymentService _paymentService;

  static void initialize() {
    _budgetService = BudgetService();
    _categoryService = CategoryService();
    _paymentService = PaymentService();
  }

  // SINGLETON ACCESSORS
  static BudgetService get budgetService => _budgetService;
  static CategoryService get categoryService => _categoryService;
  static PaymentService get paymentService => _paymentService;
}
