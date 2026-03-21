import 'package:isar/isar.dart';

import '../database/base_repository.dart';
import '../models/budget.dart';
import '../models/transaction.dart';

/// Budget Service: Business logic for budget management
///
/// Singleton service that handles budget operations, spending tracking, and budget alerts.
/// Provides high-level methods for budget management beyond basic CRUD.
class BudgetService extends BaseRepository<IsarBudget> {
  static final BudgetService _instance = BudgetService._internal();

  factory BudgetService(Isar isar) {
    _instance.setIsar(isar);
    return _instance;
  }

  BudgetService._internal() : super();

  @override
  IsarCollection<IsarBudget> get collection => isar.isarBudgets;

  /// Create a new budget for a category and period
  /// - Initializes spent to 0
  /// - Sets timestamps automatically
  Future<int> createBudget({
    required String category,
    required double limit,
    required String period, // 'monthly', 'weekly', 'yearly'
  }) async {
    final budget = IsarBudget(category: category, limit: limit, period: period, month: DateTime.now(), isActive: true);

    budget.spent = 0;
    return await create(budget);
  }

  /// Get all active budgets
  Stream<List<IsarBudget>> watchActiveBudgets() {
    return isar.isarBudgets.where().filter().isActiveEqualTo(true).watch(fireImmediately: true);
  }

  /// Get budgets for a specific month
  Future<List<IsarBudget>> getBudgetsByMonth(DateTime month) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1).subtract(const Duration(days: 1));

    return await isar.isarBudgets.where().filter().monthBetween(startOfMonth, endOfMonth).findAll();
  }

  /// Get budgets for a specific category
  Future<List<IsarBudget>> getBudgetsByCategory(String category) async {
    // Note: Isar doesn't support text equality in filter, use where query
    final all = await getAll();
    return all.where((b) => b.category == category).toList();
  }

  /// Update the amount spent on a budget
  /// - Adds amount to the current spent value
  /// - Validates against budget limit
  /// - Returns true if budget limit is not exceeded
  Future<bool> updateSpent(int budgetId, double amount) async {
    final budget = await getById(budgetId);
    if (budget == null) return false;

    budget.spent += amount;
    budget.updatedAt = DateTime.now();

    await update(budget);

    // Return false if exceeded to signal alert
    return budget.spent <= budget.limit;
  }

  /// Set the exact spent amount for a budget
  /// - Overwrites the spent value
  /// - Useful for manual sync or corrections
  Future<void> setSpent(int budgetId, double amount) async {
    final budget = await getById(budgetId);
    if (budget == null) return;

    budget.spent = amount;
    budget.updatedAt = DateTime.now();

    await update(budget);
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
  Future<List<IsarBudget>> getOverBudgets() async {
    final all = await getAll();
    return all.where((b) => b.spent > b.limit).toList();
  }

  /// Get budgets with critical status (80%+ spent)
  /// - Returns list of budgets approaching or exceeding limits
  Future<List<IsarBudget>> getCriticalBudgets() async {
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
  Future<void> recalculateSpent(int budgetId, List<IsarTransaction> transactions) async {
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

    budget.isActive = false;
    budget.updatedAt = DateTime.now();

    await update(budget);
  }

  /// Reactivate a budget
  /// - Marks budget as active again
  Future<void> reactivateBudget(int budgetId) async {
    final budget = await getById(budgetId);
    if (budget == null) return;

    budget.isActive = true;
    budget.updatedAt = DateTime.now();

    await update(budget);
  }

  /// Reset budget for new period
  /// - Clears spent amount, sets new month
  /// - Useful for recurring budgets
  Future<void> resetBudget(int budgetId, DateTime newMonth) async {
    final budget = await getById(budgetId);
    if (budget == null) return;

    budget.spent = 0;
    budget.month = newMonth;
    budget.updatedAt = DateTime.now();

    await update(budget);
  }

  /// Get budget summary statistics
  /// - Returns map with total allocated, spent, and remaining
  Future<Map<String, double>> getBudgetSummary() async {
    final totalAllocated = await getTotalBudgetAllocated();
    final totalSpent = await getTotalSpent();

    return {'allocated': totalAllocated, 'spent': totalSpent, 'remaining': totalAllocated - totalSpent};
  }
}
