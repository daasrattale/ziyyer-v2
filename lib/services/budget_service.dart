import 'package:drift/drift.dart';

import '../database/base_repository.dart';
import '../database/database.dart';
import '../models/budget_table.dart';

/// Extension to add missing helper logic to Budget data class
extension BudgetExtension on Budget {
  double get remainingBudget => limit - spent;
  double get percentageUsed => limit > 0 ? spent / limit : 0.0;
}

/// Budget Service: Business logic for budget management
///
/// Singleton service that handles budget operations, spending tracking, and budget alerts.
/// Provides high-level methods for budget management beyond basic CRUD.
class BudgetService extends BaseRepository<Budgets, Budget> {
  static final BudgetService _instance = BudgetService._internal();

  factory BudgetService(AppDatabase db) {
    _instance.setDatabase(db);
    return _instance;
  }

  BudgetService._internal() : super();

  @override
  TableInfo<Budgets, Budget> get table => db.budgets;

  /// Create a new budget for a category and period
  /// - Initializes spent to 0
  /// - Sets timestamps automatically
  Future<int> createBudget({
    required String category,
    required double limit,
    required String period, // 'monthly', 'weekly', 'yearly'
  }) async {
    final budget = BudgetsCompanion.insert(
      category: category,
      limit: limit,
      period: period,
      month: DateTime.now(),
      isActive: const Value(true),
      spent: const Value(0),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await create(budget);
  }

  /// Get all active budgets
  Stream<List<Budget>> watchActiveBudgets() {
    return (db.select(table)..where((b) => b.isActive.equals(true))).watch();
  }

  /// Get budgets for a specific month
  Future<List<Budget>> getBudgetsByMonth(DateTime month) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1).subtract(const Duration(days: 1));

    return await (db.select(table)..where((b) => b.month.isBetweenValues(startOfMonth, endOfMonth))).get();
  }

  /// Get budgets for a specific category
  Future<List<Budget>> getBudgetsByCategory(String category) async {
    return await (db.select(table)..where((b) => b.category.equals(category))).get();
  }

  /// Update the amount spent on a budget
  /// - Adds amount to the current spent value
  /// - Validates against budget limit
  /// - Returns true if budget limit is not exceeded
  Future<bool> updateSpent(int budgetId, double amount) async {
    final budget = await getById(budgetId);
    if (budget == null) return false;

    final updatedBudget = budget.copyWith(
      spent: budget.spent + amount,
      updatedAt: DateTime.now(),
    );

    await update(updatedBudget);

    // Return false if exceeded to signal alert
    return updatedBudget.spent <= updatedBudget.limit;
  }

  /// Set the exact spent amount for a budget
  /// - Overwrites the spent value
  /// - Useful for manual sync or corrections
  Future<void> setSpent(int budgetId, double amount) async {
    final budget = await getById(budgetId);
    if (budget == null) return;

    await update(budget.copyWith(spent: amount, updatedAt: DateTime.now()));
  }

  /// Check if budget is exceeded
  /// - Returns true if spent > limit
  Future<bool> isExceeded(int budgetId) async {
    final budget = await getById(budgetId);
    return budget != null && budget.spent > budget.limit;
  }

  /// Get remaining budget amount
  /// - Returns limit - spent
  /// - Can be negative if budget is exceeded
  Future<double?> getRemainingBudget(int budgetId) async {
    final budget = await getById(budgetId);
    return budget?.remainingBudget;
  }

  /// Get budget usage percentage
  /// - Returns spent / limit as 0.0 to 1.0
  /// - Can exceed 1.0 if overspent
  Future<double?> getUsagePercentage(int budgetId) async {
    final budget = await getById(budgetId);
    return budget?.percentageUsed;
  }

  /// Get budgets that are over budget
  /// - Returns list of budgets where spent > limit
  Future<List<Budget>> getOverBudgets() async {
    final all = await getAll();
    return all.where((b) => b.spent > b.limit).toList();
  }

  /// Get budgets with critical status (80%+ spent)
  /// - Returns list of budgets approaching or exceeding limits
  Future<List<Budget>> getCriticalBudgets() async {
    final all = await getAll();
    return all.where((b) => b.percentageUsed >= 0.8).toList();
  }

  /// Calculate total budget allocated for a period
  /// - Sums all budget limits for active budgets
  Future<double> getTotalBudgetAllocated() async {
    final budgets = await getAll();
    return budgets.fold<double>(0.0, (sum, b) => sum + (b.isActive ? b.limit : 0));
  }

  /// Calculate total spent across all budgets
  /// - Sums all spent amounts for active budgets
  Future<double> getTotalSpent() async {
    final budgets = await getAll();
    return budgets.fold<double>(0.0, (sum, b) => sum + (b.isActive ? b.spent : 0));
  }

  /// Recalculate spent amount for a budget based on transactions
  /// - Queries all expenses in the category for the period
  /// - Updates the budget's spent amount
  /// - Useful for syncing after data changes
  Future<void> recalculateSpent(int budgetId, List<Transaction> transactions) async {
    final budget = await getById(budgetId);
    if (budget == null) return;

    // Filter transactions by category and period
    double totalSpent = 0;
    final startOfMonth = DateTime(budget.month.year, budget.month.month, 1);
    final endOfMonth = DateTime(budget.month.year, budget.month.month + 1).subtract(const Duration(days: 1));

    for (final tx in transactions) {
      if (tx.category == budget.category && tx.type == 'expense' && tx.date.isAfter(startOfMonth) && tx.date.isBefore(endOfMonth)) {
        totalSpent += tx.amount;
      }
    }

    await setSpent(budgetId, totalSpent);
  }

  /// Deactivate a budget (soft delete)
  /// - Marks budget as inactive without removing it
  /// - Useful for archiving old budgets
  Future<void> deactivateBudget(int budgetId) async {
    final budget = await getById(budgetId);
    if (budget == null) return;

    await update(budget.copyWith(isActive: false, updatedAt: DateTime.now()));
  }

  /// Reactivate a budget
  Future<void> reactivateBudget(int budgetId) async {
    final budget = await getById(budgetId);
    if (budget == null) return;

    await update(budget.copyWith(isActive: true, updatedAt: DateTime.now()));
  }

  /// Get budget summary for the current month
  /// - Total limit, total spent, and overall percentage
  Future<Map<String, dynamic>> getCurrentMonthSummary() async {
    final budgets = await getBudgetsByMonth(DateTime.now());

    double totalLimit = 0;
    double totalSpent = 0;

    for (final b in budgets) {
      totalLimit += b.limit;
      totalSpent += b.spent;
    }

    return {
      'totalLimit': totalLimit,
      'totalSpent': totalSpent,
      'percentage': totalLimit > 0 ? totalSpent / totalLimit : 0.0,
      'count': budgets.length,
      'exceeded': budgets.where((b) => b.spent > b.limit).length,
    };
  }

  /// Reset budget for new period
  /// - Clears spent amount, sets new month
  /// - Useful for recurring budgets
  Future<void> resetBudget(int budgetId, DateTime newMonth) async {
    final budget = await getById(budgetId);
    if (budget == null) return;

    await update(budget.copyWith(spent: 0, month: newMonth, updatedAt: DateTime.now()));
  }

  /// Get budget summary statistics
  /// - Returns map with total allocated, spent, and remaining
  Future<Map<String, double>> getBudgetSummary() async {
    final totalAllocated = await getTotalBudgetAllocated();
    final totalSpent = await getTotalSpent();

    return {'allocated': totalAllocated, 'spent': totalSpent, 'remaining': totalAllocated - totalSpent};
  }
}
