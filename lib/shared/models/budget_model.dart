import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/features/budget_setup/controllers/budget_setup_controller.dart';
import 'package:ziyyer/shared/database/database.dart';
import 'package:ziyyer/shared/models/currency_model.dart';
import 'package:ziyyer/shared/models/payement_model.dart';

import 'category_model.dart';

class BudgetModel {
  int? id;
  double definedAmount;
  double realAmount;
  double allocatedAmount;
  double unallocatedAmount;
  CurrencyModel currency;
  List<CategoryModel> categories;
  List<PaymentModel>? payements;
  DateTime? createdAt;
  DateTime? updatedAt;

  BudgetModel({
    required this.id,
    required this.definedAmount,
    required this.realAmount,
    required this.allocatedAmount,
    required this.unallocatedAmount,
    required this.currency,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetModel.fromBudget(
    Budget budget, {
    required double allocatedAmount,
    required double unallocatedAmount,
    required List<CategoryModel> categories,
  }) {
    return BudgetModel(
      id: budget.id,
      definedAmount: budget.definedAmount,
      realAmount: budget.realAmount,
      allocatedAmount: allocatedAmount,
      unallocatedAmount: unallocatedAmount,
      currency: AppConstants.supportedCurrencies.where((c) => c.code == budget.currency).first,
      categories: categories,
      createdAt: budget.createdAt,
      updatedAt: budget.updatedAt,
    );
  }

  BudgetModel copyWith({List<CategoryModel>? categories, double? allocatedAmount, double? unallocatedAmount}) {
    return BudgetModel(
      id: id,
      definedAmount: definedAmount,
      realAmount: realAmount,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      unallocatedAmount: unallocatedAmount ?? this.unallocatedAmount,
      currency: currency,
      categories: categories ?? this.categories,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory BudgetModel.init() {
    return BudgetModel(
      id: null,
      definedAmount: BudgetSetupController.instance.defaultBudgetAmount,
      realAmount: 0.0,
      allocatedAmount: 0.0,
      unallocatedAmount: 0.0,
      currency: AppConstants.defaultCurrency,
      categories: [],
      createdAt: null,
      updatedAt: null,
    );
  }
}
