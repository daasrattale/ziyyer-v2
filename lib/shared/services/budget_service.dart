import 'dart:async';

import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziyyer/shared/database/database.dart';
import 'package:ziyyer/shared/database/persistence/budget_persistence.dart';
import 'package:ziyyer/shared/database/persistence/category_persistence.dart';
import 'package:ziyyer/shared/database/persistence/payment_persistence.dart';
import 'package:ziyyer/shared/database/persistence/persistence_locator.dart';
import 'package:ziyyer/shared/extensions/string_extensions.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/models/category_model.dart';
import 'package:ziyyer/shared/models/payement_model.dart';

class BudgetService {
  BudgetService();

  final BudgetPersistence _budgetPersistence = PersistenceLocator.budgetPersistence;
  final CategoryPersistence _categoryPersistence = PersistenceLocator.categoryPersistence;
  final PaymentPersistence _paymentPersistence = PersistenceLocator.paymentPersistence;

  Future<int> persist(BudgetModel model) {
    return _budgetPersistence.transaction(() async {
      final now = DateTime.now();
      final existingBudget = await _budgetPersistence.watch().first;

      final int budgetId;

      if (existingBudget == null) {
        budgetId = await _budgetPersistence.create(
          BudgetTableCompanion.insert(
            definedAmount: model.definedAmount,
            currency: model.currency.code,
            createdAt: now,
            updatedAt: now,
          ),
        );
      } else {
        budgetId = existingBudget.id;

        await _budgetPersistence.update(
          existingBudget.id,
          BudgetTableCompanion(
            definedAmount: Value(model.definedAmount),
            currency: Value(model.currency.code),
            updatedAt: Value(now),
          ),
        );
      }

      final paymentCompanions = model.payments
          .map(
            (payment) => PaymentTableCompanion.insert(
              budgetId: budgetId,
              name: payment.name.capitalizeFirst(),
              amount: payment.amount,
            ),
          )
          .toList();

      final categoryCompanions = model.categories
          .map(
            (category) => CategoryTableCompanion.insert(
              budgetId: budgetId,
              name: category.name.capitalizeFirst(),
              definedAmount: category.definedAmount,
              realAmount: Value(category.realAmount),
              createdAt: category.createdAt,
              updatedAt: category.updatedAt,
            ),
          )
          .toList();

      await _paymentPersistence.update(budgetId, paymentCompanions);
      await _categoryPersistence.update(budgetId, categoryCompanions);

      return budgetId;
    });
  }

  Stream<BudgetModel?> watch() {
    return _budgetPersistence.watch().switchMap((budget) {
      if (budget == null) {
        return Stream.value(null);
      }

      return Rx.combineLatest2<List<Category>, List<Payment>, BudgetModel>(
        _categoryPersistence.watch().startWith(const []),
        _paymentPersistence.watch().startWith(const []),
        (categories, payments) {
          final mappedCategories = categories
              .where((category) => category.budgetId == budget.id)
              .map(
                (category) => CategoryModel(
                  id: category.id,
                  name: category.name,
                  definedAmount: category.definedAmount,
                  realAmount: category.realAmount,
                  createdAt: category.createdAt,
                  updatedAt: category.updatedAt,
                ),
              )
              .toList();

          final mappedPayments = payments
              .where((payment) => payment.budgetId == budget.id)
              .map((payment) => PaymentModel(id: payment.id, name: payment.name, amount: payment.amount))
              .toList();

          return BudgetModel.fromBudget(
            budget,
            categories: mappedCategories,
            payments: mappedPayments,
            allocatedAmount: 0,
            unallocatedAmount: 0,
          );
        },
      );
    });
  }
}
