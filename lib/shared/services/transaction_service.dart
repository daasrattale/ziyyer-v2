import 'package:drift/drift.dart';
import 'package:ziyyer/shared/database/database.dart';
import 'package:ziyyer/shared/database/persistence/category_persistence.dart';
import 'package:ziyyer/shared/database/persistence/persistence_locator.dart';
import 'package:ziyyer/shared/database/persistence/transaction_persistence.dart';
import 'package:ziyyer/shared/models/transaction_model.dart';

class TransactionService {
  TransactionService();

  final CategoryPersistence _categoryPersistence = PersistenceLocator.categoryPersistence;
  final TransactionPersistence _transactionPersistence = PersistenceLocator.transactionPersistence;

  Future<void> persist({required double amount, int? categoryId, String? description, DateTime? date, String? paymentMethod}) async {
    final categories = await _categoryPersistence.watch().first;

    Category? resolvedCategory;

    if (categoryId != null) {
      try {
        resolvedCategory = categories.firstWhere((category) => category.id == categoryId);
      } catch (_) {
        resolvedCategory = null;
      }
    }

    resolvedCategory ??= categories.cast<Category?>().firstWhere(
      (category) => category?.name.toLowerCase() == 'other',
      orElse: () => null,
    );

    if (resolvedCategory == null) {
      final now = DateTime.now();

      final budgetCategories = categories.toList();
      if (budgetCategories.isEmpty) {
        throw Exception('No budget/category available to attach transaction.');
      }

      final fallbackBudgetId = budgetCategories.first.budgetId;

      await _categoryPersistence.create([
        CategoryTableCompanion.insert(
          budgetId: fallbackBudgetId,
          name: 'Other',
          definedAmount: 0,
          realAmount: const Value(0),
          createdAt: now,
          updatedAt: now,
        ),
      ]);

      final refreshedCategories = await _categoryPersistence.watch().first;
      resolvedCategory = refreshedCategories.firstWhere((category) => category.name.toLowerCase() == 'other');
    }

    await _transactionPersistence.create(
      TransactionTableCompanion.insert(
        categoryId: resolvedCategory.id,
        amount: amount,
        date: date ?? DateTime.now(),
        description: Value(description?.trim().isEmpty == true ? null : description?.trim()),
        paymentMethod: Value(paymentMethod?.trim().isEmpty == true ? null : paymentMethod?.trim()),
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> delete(TransactionModel transaction) async {
    final id = transaction.id;

    final affectedRows = await _transactionPersistence.deleteById(id);

    if (affectedRows == 0) {
      throw StateError('Transaction not found.');
    }
  }

  Future<void> update(TransactionModel transaction) async {
    final id = transaction.id;

    final affectedRows = await _transactionPersistence.updateById(
      id,
      TransactionTableCompanion(
        categoryId: Value(transaction.categoryId),
        amount: Value(transaction.amount),
        date: Value(transaction.date),
        description: Value(transaction.description),
        paymentMethod: Value(transaction.paymentMethod),
        createdAt: Value(transaction.createdAt),
      ),
    );

    if (affectedRows == 0) {
      throw StateError('Transaction not found.');
    }
  }
}
