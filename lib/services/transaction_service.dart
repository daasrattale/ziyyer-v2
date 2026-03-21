import 'package:isar/isar.dart';

import '../database/base_repository.dart';
import '../models/transaction.dart';

/// Transaction Service: Business logic for transaction management
///
/// Singleton service that handles transaction operations, analytics, and reporting.
/// Provides methods for transaction queries and financial calculations.
class TransactionService extends BaseRepository<IsarTransaction> {
  static final TransactionService _instance = TransactionService._internal();

  factory TransactionService(Isar isar) {
    _instance.setIsar(isar);
    return _instance;
  }

  TransactionService._internal() : super();

  @override
  IsarCollection<IsarTransaction> get collection => isar.isarTransactions;

  /// Create a new transaction
  /// - Records income or expense
  /// - Associates with account
  Future<int> createTransaction({
    required int accountId,
    required String description,
    required double amount,
    required String type, // 'income' or 'expense'
    required DateTime date,
    String? category,
    String? notes,
  }) async {
    final transaction = IsarTransaction(
      accountId: accountId,
      description: description,
      amount: amount,
      type: type,
      date: date,
      category: category,
      notes: notes,
    );
    return await create(transaction);
  }

  /// Get transactions for a specific account
  Stream<List<IsarTransaction>> watchTransactionsByAccount(int accountId) {
    return isar.isarTransactions.filter().accountIdEqualTo(accountId).watch(fireImmediately: true);
  }

  /// Get all transactions for an account
  Future<List<IsarTransaction>> getTransactionsByAccount(int accountId) async {
    return await isar.isarTransactions.filter().accountIdEqualTo(accountId).findAll();
  }

  /// Get transactions in a date range
  /// - From start date to end date (inclusive)
  Future<List<IsarTransaction>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    return await isar.isarTransactions.filter().dateBetween(start, end).findAll();
  }

  /// Get transactions by account and date range
  Future<List<IsarTransaction>> getTransactionsByAccountAndDateRange(int accountId, DateTime start, DateTime end) async {
    return await isar.isarTransactions.where().filter().accountIdEqualTo(accountId).and().dateBetween(start, end).findAll();
  }

  /// Get transactions by category
  /// - Returns all transactions with matching category
  Future<List<IsarTransaction>> getTransactionsByCategory(String category) async {
    final all = await getAll();
    return all.where((t) => t.category == category).toList();
  }

  /// Get transactions by type (income or expense)
  Future<List<IsarTransaction>> getTransactionsByType(String type) async {
    final all = await getAll();
    return all.where((t) => t.type == type).toList();
  }

  /// Calculate total income for an account
  /// - Optionally filter by date range
  Future<double> getTotalIncome(int accountId, {DateTime? start, DateTime? end}) async {
    final transactions = await getTransactionsByAccount(accountId);
    double total = 0;

    for (final tx in transactions) {
      if (tx.type == 'income') {
        if (start != null && end != null) {
          if (tx.date.isAfter(start) && tx.date.isBefore(end)) {
            total += tx.amount;
          }
        } else {
          total += tx.amount;
        }
      }
    }
    return total;
  }

  /// Calculate total expenses for an account
  /// - Optionally filter by date range
  Future<double> getTotalExpense(int accountId, {DateTime? start, DateTime? end}) async {
    final transactions = await getTransactionsByAccount(accountId);
    double total = 0;

    for (final tx in transactions) {
      if (tx.type == 'expense') {
        if (start != null && end != null) {
          if (tx.date.isAfter(start) && tx.date.isBefore(end)) {
            total += tx.amount;
          }
        } else {
          total += tx.amount;
        }
      }
    }
    return total;
  }

  /// Calculate net income (income - expenses) for an account
  /// - Optionally filter by date range
  Future<double> getNetIncome(int accountId, {DateTime? start, DateTime? end}) async {
    final income = await getTotalIncome(accountId, start: start, end: end);
    final expenses = await getTotalExpense(accountId, start: start, end: end);
    return income - expenses;
  }

  /// Get income by category
  /// - Sums all income transactions in a category
  Future<double> getIncomeByCategory(String category) async {
    final transactions = await getTransactionsByCategory(category);
    return transactions.fold<double>(0.0, (sum, t) => sum + (t.type == 'income' ? t.amount : 0));
  }

  /// Get expenses by category
  /// - Sums all expense transactions in a category
  Future<double> getExpenseByCategory(String category) async {
    final transactions = await getTransactionsByCategory(category);
    return transactions.fold<double>(0.0, (sum, t) => sum + (t.type == 'expense' ? t.amount : 0));
  }

  /// Get all categories used in transactions
  Future<List<String>> getAllCategories() async {
    final all = await getAll();
    final categories = <String>{};
    for (final tx in all) {
      if (tx.category != null) {
        categories.add(tx.category!);
      }
    }
    return categories.toList();
  }

  /// Get transactions for the current month
  Future<List<IsarTransaction>> getCurrentMonthTransactions(int accountId) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1).subtract(const Duration(days: 1));

    return await getTransactionsByAccountAndDateRange(accountId, start, end);
  }

  /// Get transactions for a specific month
  Future<List<IsarTransaction>> getMonthTransactions(int accountId, int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1).subtract(const Duration(days: 1));

    return await getTransactionsByAccountAndDateRange(accountId, start, end);
  }

  /// Get average daily spending for a date range
  Future<double> getAverageDailySpending(int accountId, DateTime start, DateTime end) async {
    final transactions = await getTransactionsByAccountAndDateRange(accountId, start, end);
    double totalExpense = 0;

    for (final tx in transactions) {
      if (tx.type == 'expense') {
        totalExpense += tx.amount;
      }
    }

    final days = end.difference(start).inDays + 1;
    return days > 0 ? totalExpense / days : 0;
  }

  /// Get transaction counts by type and period
  Future<Map<String, int>> getTransactionCounts(int accountId) async {
    final transactions = await getTransactionsByAccount(accountId);

    return {
      'income': transactions.where((t) => t.type == 'income').length,
      'expense': transactions.where((t) => t.type == 'expense').length,
      'total': transactions.length,
    };
  }

  /// Get largest transactions (by amount)
  /// - Returns top N transactions sorted by amount
  Future<List<IsarTransaction>> getLargestTransactions(int accountId, {int limit = 10}) async {
    final transactions = await getTransactionsByAccount(accountId);
    transactions.sort((a, b) => b.amount.compareTo(a.amount));
    return transactions.take(limit).toList();
  }

  /// Get most recent transactions
  /// - Returns newest transactions first
  Future<List<IsarTransaction>> getRecentTransactions(int accountId, {int limit = 20}) async {
    final transactions = await getTransactionsByAccount(accountId);
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions.take(limit).toList();
  }

  /// Get transaction summary for a period
  /// - Returns summary stats (counts, totals, average)
  Future<Map<String, dynamic>> getTransactionSummary(int accountId, {DateTime? start, DateTime? end}) async {
    final transactions = start != null && end != null
        ? await getTransactionsByAccountAndDateRange(accountId, start, end)
        : await getTransactionsByAccount(accountId);

    final income = transactions.fold<double>(0.0, (sum, t) => sum + (t.type == 'income' ? t.amount : 0));
    final expenses = transactions.fold<double>(0.0, (sum, t) => sum + (t.type == 'expense' ? t.amount : 0));
    final incomeCount = transactions.where((t) => t.type == 'income').length;
    final expenseCount = transactions.where((t) => t.type == 'expense').length;

    return {
      'totalIncome': income,
      'totalExpense': expenses,
      'net': income - expenses,
      'incomeCount': incomeCount,
      'expenseCount': expenseCount,
      'totalCount': transactions.length,
      'averageTransaction': transactions.isEmpty ? 0 : (income + expenses) / transactions.length,
    };
  }
}
