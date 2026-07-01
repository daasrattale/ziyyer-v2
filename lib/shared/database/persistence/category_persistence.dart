import 'package:ziyyer/shared/database/database.dart';
import 'package:ziyyer/shared/models/category_model.dart';

class CategoryPersistence {
  CategoryPersistence(this._db);

  final AppDatabase _db;

  /// Returns all categories for the given budget id.
  Future<List<CategoryModel>> getCategoriesForBudget(int budgetId) async {
    final categories = await (_db.select(_db.categoryTable)..where((tbl) => tbl.budgetId.equals(budgetId))).get();

    return categories
        .map(
          (category) => CategoryModel(
            id: category.id,
            budgetId: category.budgetId,
            name: category.name,
            definedAmount: category.definedAmount,
            realAmount: category.realAmount,
            createdAt: category.createdAt,
            updatedAt: category.updatedAt,
          ),
        )
        .toList();
  }

  /// Streams all categories for the given budget id.
  Stream<List<CategoryModel>> watchCategoriesForBudget(int budgetId) {
    return (_db.select(_db.categoryTable)..where((tbl) => tbl.budgetId.equals(budgetId))).watch().map(
      (categories) => categories
          .map(
            (category) => CategoryModel(
              id: category.id,
              budgetId: category.budgetId,
              name: category.name,
              definedAmount: category.definedAmount,
              realAmount: category.realAmount,
              createdAt: category.createdAt,
              updatedAt: category.updatedAt,
            ),
          )
          .toList(),
    );
  }

  // todo: create a function that saves a category and bulk of categories
}
