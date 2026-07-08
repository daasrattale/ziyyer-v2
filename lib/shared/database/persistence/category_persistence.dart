import 'package:ziyyer/shared/database/database.dart';

class CategoryPersistence {
  CategoryPersistence(this.db);

  final AppDatabase db;

  Future<void> create(List<CategoryTableCompanion> companions) async {
    if (companions.isEmpty) return;

    await db.batch((batch) {
      batch.insertAll(db.categoryTable, companions);
    });
  }

  Future<void> update(int budgetId, List<CategoryTableCompanion> companions) async {
    await (db.delete(db.categoryTable)..where((t) => t.budgetId.equals(budgetId))).go();

    if (companions.isEmpty) return;

    await db.batch((batch) {
      batch.insertAll(db.categoryTable, companions);
    });
  }

  Stream<List<Category>> watch() {
    return db.select(db.categoryTable).watch();
  }
}
