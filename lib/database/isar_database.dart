import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/account.dart';
import '../models/budget.dart';
import '../models/transaction.dart';

class IsarDatabase {
  static final IsarDatabase _instance = IsarDatabase._internal();
  static late Isar _isar;

  factory IsarDatabase() => _instance;

  IsarDatabase._internal();

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([IsarAccountSchema, IsarTransactionSchema, IsarBudgetSchema], directory: dir.path);
  }

  static Isar get isar => _isar;

  // Account Methods
  Future<int> createAccount(IsarAccount account) async {
    return await _isar.writeTxn(() => _isar.isarAccounts.put(account));
  }

  Future<void> updateAccount(IsarAccount account) async {
    await _isar.writeTxn(() => _isar.isarAccounts.put(account));
  }

  Future<bool> deleteAccount(int id) async {
    return await _isar.writeTxn(() => _isar.isarAccounts.delete(id));
  }

  Stream<List<IsarAccount>> watchAllAccounts() {
    return _isar.isarAccounts.where().watch(fireImmediately: true);
  }

  Stream<IsarAccount?> watchAccount(int id) {
    return _isar.isarAccounts.watchObject(id, fireImmediately: true);
  }

  Future<IsarAccount?> getAccount(int id) async {
    return await _isar.isarAccounts.get(id);
  }

  Future<List<IsarAccount>> getAllAccounts() async {
    return await _isar.isarAccounts.where().findAll();
  }

  // Transaction Methods
  Future<int> createTransaction(IsarTransaction transaction) async {
    return await _isar.writeTxn(() => _isar.isarTransactions.put(transaction));
  }

  Future<void> updateTransaction(IsarTransaction transaction) async {
    await _isar.writeTxn(() => _isar.isarTransactions.put(transaction));
  }

  Future<bool> deleteTransaction(int id) async {
    return await _isar.writeTxn(() => _isar.isarTransactions.delete(id));
  }

  Stream<List<IsarTransaction>> watchTransactionsByAccount(int accountId) {
    return _isar.isarTransactions.where().accountIdEqualTo(accountId).watch(fireImmediately: true);
  }

  Stream<List<IsarTransaction>> watchAllTransactions() {
    return _isar.isarTransactions.where().watch(fireImmediately: true);
  }

  Future<List<IsarTransaction>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    return await _isar.isarTransactions.where().dateBetween(start, end).findAll();
  }

  Future<List<IsarTransaction>> getTransactionsByAccount(int accountId) async {
    return await _isar.isarTransactions.where().accountIdEqualTo(accountId).findAll();
  }

  Future<double> getTotalIncomeByAccount(int accountId, {DateTime? startDate, DateTime? endDate}) async {
    final transactions = await getTransactionsByAccount(accountId);
    double total = 0;

    for (final transaction in transactions) {
      if (transaction.type == 'income') {
        if (startDate != null && endDate != null) {
          if (transaction.date.isAfter(startDate) && transaction.date.isBefore(endDate)) {
            total += transaction.amount;
          }
        } else {
          total += transaction.amount;
        }
      }
    }
    return total;
  }

  Future<double> getTotalExpenseByAccount(int accountId, {DateTime? startDate, DateTime? endDate}) async {
    final transactions = await getTransactionsByAccount(accountId);
    double total = 0;

    for (final transaction in transactions) {
      if (transaction.type == 'expense') {
        if (startDate != null && endDate != null) {
          if (transaction.date.isAfter(startDate) && transaction.date.isBefore(endDate)) {
            total += transaction.amount;
          }
        } else {
          total += transaction.amount;
        }
      }
    }
    return total;
  }

  // Budget Methods
  Future<int> createBudget(IsarBudget budget) async {
    return await _isar.writeTxn(() => _isar.isarBudgets.put(budget));
  }

  Future<void> updateBudget(IsarBudget budget) async {
    await _isar.writeTxn(() => _isar.isarBudgets.put(budget));
  }

  Future<bool> deleteBudget(int id) async {
    return await _isar.writeTxn(() => _isar.isarBudgets.delete(id));
  }

  Stream<List<IsarBudget>> watchAllBudgets() {
    return _isar.isarBudgets.where().watch(fireImmediately: true);
  }

  Stream<List<IsarBudget>> watchActiveBudgets() {
    return _isar.isarBudgets.where().filter().isActiveEqualTo(true).watch(fireImmediately: true);
  }

  Future<List<IsarBudget>> getAllBudgets() async {
    return await _isar.isarBudgets.where().findAll();
  }

  // Cleanup
  Future<void> close() async {
    await _isar.close();
  }

  // Reset database (for development)
  Future<void> clear() async {
    await _isar.writeTxn(() async {
      await _isar.isarAccounts.clear();
      await _isar.isarTransactions.clear();
      await _isar.isarBudgets.clear();
    });
  }
}
