import 'package:ziyyer/shared/database/database.dart';
import 'package:ziyyer/shared/models/budget_model.dart';

class BudgetPersistence {
  BudgetPersistence(this._db);

  final AppDatabase _db;

  /// Returns `true` if a budget row exists in the database.
  ///
  /// This method performs a one-time query against the budget table and
  /// returns `false` if no budget record is found.
  Future<bool> budgetExists() async {
    final budget = await _db.select(_db.budgetTable).getSingleOrNull();
    return budget != null;
  }

  /// Watches whether a budget row exists in the database.
  ///
  /// The returned stream emits `true` when the budget table contains a budget
  /// record and `false` when it is empty. It updates automatically whenever
  /// the underlying budget table changes.
  Stream<bool> watchBudgetExists() {
    return _db.select(_db.budgetTable).watchSingleOrNull().map((budget) {
      return budget != null;
    });
  }

  /// Streams the current budget row, or `null` if none exists.
  Stream<Budget?> watchBudgetRow() {
    return _db.select(_db.budgetTable).watchSingleOrNull();
  }

  /// Stream of the current budget, or null if none exists.
  Stream<BudgetModel?> watchBudget() {
    return _db
        .select(_db.budgetTable)
        .watchSingleOrNull()
        .where((event) => event != null)
        // Calculation and categories retrieval are done on the service layer
        .map((event) => BudgetModel.fromBudget(event!, allocatedAmount: 0, unallocatedAmount: 0, categories: List.empty()));
  }

  // todo: create a function that saves a budget
}
