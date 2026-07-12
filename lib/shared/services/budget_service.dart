import 'dart:async';

import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ziyyer/shared/database/database.dart';
import 'package:ziyyer/shared/database/persistence/budget_persistence.dart';
import 'package:ziyyer/shared/database/persistence/category_persistence.dart';
import 'package:ziyyer/shared/database/persistence/payment_persistence.dart';
import 'package:ziyyer/shared/database/persistence/persistence_locator.dart';
import 'package:ziyyer/shared/database/persistence/transaction_persistence.dart';
import 'package:ziyyer/shared/extensions/string_extensions.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/models/category_model.dart';
import 'package:ziyyer/shared/models/payement_model.dart';
import 'package:ziyyer/shared/models/transaction_model.dart';

class BudgetService {
  BudgetService();

  final BudgetPersistence _budgetPersistence = PersistenceLocator.budgetPersistence;
  final CategoryPersistence _categoryPersistence = PersistenceLocator.categoryPersistence;
  final PaymentPersistence _paymentPersistence = PersistenceLocator.paymentPersistence;
  final TransactionPersistence _transactionPersistence = PersistenceLocator.transactionPersistence;

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
            isSetup: Value(model.isSetup),
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
            isSetup: Value(model.isSetup),
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

      final normalizedCategories = model.categories
          .map((category) => category.copyWith(name: category.name.capitalizeFirst(), updatedAt: now))
          .toList();

      await _paymentPersistence.update(budgetId, paymentCompanions);
      await _categoryPersistence.update(budgetId, normalizedCategories);

      return budgetId;
    });
  }

  Stream<BudgetModel?> watch() {
    return _budgetPersistence.watch().startWith(null).switchMap((budget) {
      if (budget == null) {
        return Stream.value(null);
      }

      return Rx.combineLatest3<List<Category>, List<Payment>, List<Transaction>, BudgetModel>(
        _categoryPersistence.watch().startWith(const []),
        _paymentPersistence.watch().startWith(const []),
        _transactionPersistence.watch().startWith(const []),
        (categories, payments, transactions) {
          final budgetCategories = categories.where((category) => category.budgetId == budget.id).map((category) {
            final categoryTransactions = transactions
                .where((transaction) => transaction.categoryId == category.id)
                .map(
                  (transaction) => TransactionModel(
                    id: transaction.id,
                    categoryId: transaction.categoryId,
                    amount: transaction.amount,
                    date: transaction.date,
                    description: transaction.description,
                    createdAt: transaction.createdAt,
                  ),
                )
                .toList();

            return CategoryModel(
              id: category.id,
              name: category.name,
              definedAmount: category.definedAmount,
              transactions: categoryTransactions,
              createdAt: category.createdAt,
              updatedAt: category.updatedAt,
            );
          }).toList();

          final mappedPayments = payments
              .where((payment) => payment.budgetId == budget.id)
              .map((payment) => PaymentModel(id: payment.id, name: payment.name, amount: payment.amount))
              .toList();

          return BudgetModel.fromBudget(
            budget,
            categories: budgetCategories,
            payments: mappedPayments,
            allocatedAmount: 0,
            unallocatedAmount: 0,
          );
        },
      );
    });
  }
}
