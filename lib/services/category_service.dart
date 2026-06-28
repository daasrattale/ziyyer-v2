import 'package:drift/drift.dart';
import 'package:ziyyer/database/database.dart';

class CategoryService {
  CategoryService(this.db);

  final AppDatabase db;

  Future<Category> createCategory({
    required int budgetId,
    required String name,
    required double definedAmount,
  }) async {
    final now = DateTime.now();

    return db
        .into(db.categoryTable)
        .insertReturning(
          CategoryTableCompanion.insert(
            budgetId: budgetId,
            name: name,
            definedAmount: definedAmount,
            realAmount: const Value(0),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }
}
