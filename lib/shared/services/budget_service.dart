import 'dart:async';

import 'package:ziyyer/shared/database/persistence/budget_persistence.dart';
import 'package:ziyyer/shared/database/persistence/category_persistence.dart';
import 'package:ziyyer/shared/database/persistence/persistence_locator.dart';
import 'package:ziyyer/shared/models/budget_model.dart';
import 'package:ziyyer/shared/models/category_model.dart';

class BudgetService {
  BudgetService();

  final BudgetPersistence _budgetPersistence = PersistenceLocator.budgetPersistence;
  final CategoryPersistence _categoryPersistence = PersistenceLocator.categoryPersistence;

  /// Returns `true` if a budget row exists in the database.
  ///
  /// This method performs a one-time query against the budget table and
  /// returns `false` if no budget record is found.
  Future<bool> budgetExists() async {
    return _budgetPersistence.budgetExists();
  }

  /// Watches whether a budget row exists in the database.
  ///
  /// The returned stream emits `true` when the budget table contains a budget
  /// record and `false` when it is empty. It updates automatically whenever
  /// the underlying budget table changes.
  Stream<bool> watchBudgetExists() {
    return _budgetPersistence.watchBudgetExists();
  }

  /// Watches the current budget and enriches it with category details.
  ///
  /// The returned stream emits a `BudgetModel` containing the latest budget
  /// values along with category allocations, allocated amount, and
  /// unallocated amount. If no budget exists, the stream emits `null`.
  Stream<BudgetModel?> watchBudgetWithCategories() {
    final controller = StreamController<BudgetModel?>();
    StreamSubscription<BudgetModel?>? budgetSubscription;
    StreamSubscription<List<CategoryModel>>? categorySubscription;
    BudgetModel? latestBudget;

    void subscribeToCategories() {
      categorySubscription?.cancel();

      final budget = latestBudget;
      if (budget == null || budget.id == null) {
        controller.add(null);
        return;
      }

      categorySubscription = _categoryPersistence.watchCategoriesForBudget(budget.id!).listen((categories) {
        final allocatedAmount = categories.fold<double>(0, (sum, category) => sum + category.definedAmount);
        final unallocatedAmount = budget.definedAmount - allocatedAmount;

        controller.add(
          budget.copyWith(
            allocatedAmount: allocatedAmount,
            unallocatedAmount: unallocatedAmount,
            categories: categories,
          ),
        );
      }, onError: controller.addError);
    }

    controller.onListen = () {
      budgetSubscription = _budgetPersistence.watchBudget().listen(
        (budget) {
          latestBudget = budget;
          if (budget == null) {
            categorySubscription?.cancel();
            categorySubscription = null;
            controller.add(null);
            return;
          }

          subscribeToCategories();
        },
        onError: controller.addError,
        onDone: controller.close,
      );
    };

    controller.onCancel = () async {
      await budgetSubscription?.cancel();
      await categorySubscription?.cancel();
    };

    return controller.stream;
  }

  /// Creates a new budget row in the database.
  Future<void> createBudget({required double definedAmount, required String currency}) async {
    await _budgetPersistence.createBudget(definedAmount: definedAmount, currency: currency);
  }
}
