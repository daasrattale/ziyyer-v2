import 'package:drift/drift.dart';
import 'package:ziyyer/shared/database/database.dart';
import 'package:ziyyer/shared/models/category_model.dart';

class CategoryPersistence {
  CategoryPersistence(this.db);

  final AppDatabase db;

  Future<void> create(List<CategoryTableCompanion> companions) async {
    if (companions.isEmpty) return;

    await db.batch((batch) {
      batch.insertAll(db.categoryTable, companions);
    });
  }

  Future<List<Category>> getByBudgetId(int budgetId) {
    return (db.select(db.categoryTable)..where((t) => t.budgetId.equals(budgetId))).get();
  }

  Future<void> update(int budgetId, List<CategoryModel> categories) async {
    final existingCategories = await getByBudgetId(budgetId);

    final existingById = {for (final category in existingCategories) category.id: category};

    final existingByNormalizedName = {
      for (final category in existingCategories) category.name.trim().toLowerCase(): category,
    };

    await db.transaction(() async {
      for (final category in categories) {
        final normalizedName = category.name.trim().toLowerCase();

        final existingByIdMatch = existingById[category.id];

        final existingByNameMatch = existingByNormalizedName[normalizedName];

        final existingMatch = existingByIdMatch ?? existingByNameMatch;

        if (existingMatch != null) {
          await (db.update(db.categoryTable)..where((t) => t.id.equals(existingMatch.id))).write(
            CategoryTableCompanion(
              name: Value(category.name),
              definedAmount: Value(category.definedAmount),
              realAmount: Value(category.realAmount),
              updatedAt: Value(category.updatedAt),
            ),
          );
        } else {
          await db
              .into(db.categoryTable)
              .insert(
                CategoryTableCompanion.insert(
                  budgetId: budgetId,
                  name: category.name,
                  definedAmount: category.definedAmount,
                  realAmount: Value(category.realAmount),
                  createdAt: category.createdAt,
                  updatedAt: category.updatedAt,
                ),
              );
        }
      }
    });
  }

  Stream<List<Category>> watch() {
    return db.select(db.categoryTable).watch();
  }
}
