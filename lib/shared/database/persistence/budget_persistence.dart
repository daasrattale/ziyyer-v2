import 'package:ziyyer/shared/database/database.dart';

class BudgetPersistence {
  BudgetPersistence(this.db);

  final AppDatabase db;

  Future<T> transaction<T>(Future<T> Function() action) {
    return db.transaction(action);
  }

  Future<int> create(BudgetTableCompanion companion) {
    return db.into(db.budgetTable).insert(companion);
  }

  Future<int> update(int budgetId, BudgetTableCompanion companion) {
    return (db.update(db.budgetTable)..where((t) => t.id.equals(budgetId))).write(companion);
  }

  Stream<Budget?> watch() {
    return (db.select(db.budgetTable)..limit(1)).watchSingleOrNull();
  }
}
