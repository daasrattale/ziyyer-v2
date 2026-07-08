import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/shared/database/database.dart';
import 'package:ziyyer/shared/models/currency_model.dart';
import 'package:ziyyer/shared/models/payement_model.dart';

import 'category_model.dart';

class BudgetModel {
  int? id;
  double definedAmount;
  CurrencyModel currency;
  List<CategoryModel> categories;
  List<PaymentModel> payments;
  DateTime? createdAt;
  DateTime? updatedAt;

  BudgetModel({
    required this.id,
    required this.definedAmount,
    required this.currency,
    required this.categories,
    required this.payments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetModel.fromBudget(
    Budget budget, {
    required double allocatedAmount,
    required double unallocatedAmount,
    required List<CategoryModel> categories,
    required List<PaymentModel> payments,
  }) {
    return BudgetModel(
      id: budget.id,
      definedAmount: budget.definedAmount,
      currency: AppConstants.supportedCurrencies.where((c) => c.code == budget.currency).first,
      categories: categories,
      payments: payments,
      createdAt: budget.createdAt,
      updatedAt: budget.updatedAt,
    );
  }

  BudgetModel copyWith({
    List<CategoryModel>? categories,
    double? allocatedAmount,
    double? unallocatedAmount,
    List<PaymentModel>? payments,
  }) {
    return BudgetModel(
      id: id,
      definedAmount: definedAmount,
      currency: currency,
      categories: categories ?? this.categories,
      payments: payments ?? this.payments,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory BudgetModel.init() {
    return BudgetModel(
      id: null,
      definedAmount: 2500,
      currency: AppConstants.defaultCurrency,
      categories: [],
      payments: [],
      createdAt: null,
      updatedAt: null,
    );
  }

  // Getters
  double get allocatedCategoriesAmount => categories.fold<double>(0, (sum, category) => sum + category.definedAmount);
  double get allocatedPayementsAmount => payments.fold<double>(0, (sum, payment) => sum + payment.amount);
  double get allocatedAmount => allocatedCategoriesAmount + allocatedPayementsAmount;
  double get unallocatedAmount => definedAmount - allocatedAmount;
  double get balance => definedAmount - realAmount;
  bool get isSetup => definedAmount > 0 && categories.isNotEmpty;

  double get realAmount => categories.fold<double>(0, (sum, category) => sum + category.realAmount);

  @override
  String toString() {
    return 'id=$id definedAmount=$definedAmount allocatedAmount=$allocatedAmount unallocatedAmount=$unallocatedAmount currency=$currency categories=$categories payments=$payments createdAt=$createdAt updatedAt=$updatedAt';
  }
}
