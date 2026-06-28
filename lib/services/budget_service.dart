import 'package:drift/drift.dart';
import 'package:ziyyer/database/database.dart';
import 'package:ziyyer/model/budget_details.dart';
import 'package:ziyyer/model/budget_setup_result.dart';
import 'package:ziyyer/model/budget_with_categories.dart';
import 'package:ziyyer/model/category_details.dart';

class BudgetService {
  BudgetService(this.db);

  final AppDatabase db;

  Future<bool> budgetExists() async {
    final budget = await db.select(db.budgetTable).getSingleOrNull();
    return budget != null;
  }

  Stream<bool> watchBudgetExists() {
    return db.select(db.budgetTable).watchSingleOrNull().map((budget) {
      return budget != null;
    });
  }

  // Stream<Budget?> watchBudget() {
  //   return db.select(db.budgetTable).watchSingleOrNull();
  // }

  Future<BudgetWithCategories> createBudgetWithCategories(
    BudgetSetupResult input,
  ) async {
    return db.transaction(() async {
      final isBudgetExist = await budgetExists();

      if (isBudgetExist) {
        throw StateError('A budget already exists on this device');
      }

      final now = DateTime.now();

      final budget = await db
          .into(db.budgetTable)
          .insertReturning(
            BudgetTableCompanion.insert(
              definedAmount: input.definedAmount,
              currency: input.currency,
              realAmount: const Value(0),
              createdAt: now,
              updatedAt: now,
            ),
          );

      final categories = <Category>[];

      for (final item in input.categories) {
        final category = await db
            .into(db.categoryTable)
            .insertReturning(
              CategoryTableCompanion.insert(
                budgetId: budget.id,
                name: item.name,
                definedAmount: item.definedAmount,
                realAmount: const Value(0),
                createdAt: now,
                updatedAt: now,
              ),
            );

        categories.add(category);
      }

      return BudgetWithCategories(budget: budget, categories: categories);
    });
  }

  Stream<BudgetDetails?> watchBudget() async* {
    yield await getBudget();

    await for (final _ in db.tableUpdates(
      TableUpdateQuery.onAllTables([
        db.budgetTable,
        db.categoryTable,
        db.transactionTable,
      ]),
    )) {
      yield await getBudget();
    }
  }

  Future<BudgetDetails?> getBudget() async {
    final budget = await db.select(db.budgetTable).getSingleOrNull();
    if (budget == null) return null;

    final categories = await (db.select(
      db.categoryTable,
    )..where((c) => c.budgetId.equals(budget.id))).get();

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month);
    final nextMonthStart = now.month == 12
        ? DateTime(now.year + 1, 1)
        : DateTime(now.year, now.month + 1);

    final categoryDetails = <CategoryDetails>[];

    for (final category in categories) {
      final categorySpent = await _getCategorySpentForMonth(
        categoryId: category.id,
        monthStart: monthStart,
        nextMonthStart: nextMonthStart,
      );

      categoryDetails.add(
        CategoryDetails(
          id: category.id,
          budgetId: category.budgetId,
          name: category.name,
          definedAmount: category.definedAmount,
          realAmount: categorySpent,
          createdAt: category.createdAt,
          updatedAt: category.updatedAt,
        ),
      );
    }

    final allocatedAmount = categoryDetails.fold<double>(
      0,
      (sum, category) => sum + category.definedAmount,
    );

    final realAmount = categoryDetails.fold<double>(
      0,
      (sum, category) => sum + category.realAmount,
    );

    final unallocatedAmount = budget.definedAmount - allocatedAmount;

    return BudgetDetails(
      id: budget.id,
      definedAmount: budget.definedAmount,
      realAmount: realAmount,
      allocatedAmount: allocatedAmount,
      unallocatedAmount: unallocatedAmount,
      currency: budget.currency,
      categories: categoryDetails,
      createdAt: budget.createdAt,
      updatedAt: budget.updatedAt,
    );
  }

  Future<double> _getCategorySpentForMonth({
    required int categoryId,
    required DateTime monthStart,
    required DateTime nextMonthStart,
  }) async {
    final spentAmount = db.transactionTable.amount.sum();

    final query = db.selectOnly(db.transactionTable)
      ..addColumns([spentAmount])
      ..where(
        db.transactionTable.categoryId.equals(categoryId) &
            db.transactionTable.date.isBiggerOrEqualValue(monthStart) &
            db.transactionTable.date.isSmallerThanValue(nextMonthStart),
      );

    final row = await query.getSingle();
    return ((row.read(spentAmount) as num?) ?? 0).toDouble();
  }
}
