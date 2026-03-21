import 'package:flutter/material.dart';
import 'package:ziyyer/database/isar_database.dart';
import 'package:ziyyer/models/account.dart';
import 'package:ziyyer/models/budget.dart';
import 'package:ziyyer/models/transaction.dart';

class AppProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';

  final _db = IsarDatabase();

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Account Management
  Future<int> createAccount(IsarAccount account) async {
    try {
      setLoading(true);
      int id = await _db.createAccount(account);
      clearError();
      return id;
    } catch (e) {
      setError('Failed to create account: $e');
      return -1;
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateAccount(IsarAccount account) async {
    try {
      setLoading(true);
      await _db.updateAccount(account);
      clearError();
    } catch (e) {
      setError('Failed to update account: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<bool> deleteAccount(int id) async {
    try {
      setLoading(true);
      bool deleted = await _db.deleteAccount(id);
      clearError();
      return deleted;
    } catch (e) {
      setError('Failed to delete account: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Reactive Streams
  Stream<List<IsarAccount>> get accountsStream => _db.watchAllAccounts();

  Stream<List<IsarTransaction>> getTransactionsStream(int accountId) {
    return _db.watchTransactionsByAccount(accountId);
  }

  Stream<List<IsarBudget>> get budgetsStream => _db.watchActiveBudgets();

  // Transaction Management
  Future<int> createTransaction(IsarTransaction transaction) async {
    try {
      setLoading(true);
      int id = await _db.createTransaction(transaction);
      clearError();
      return id;
    } catch (e) {
      setError('Failed to create transaction: $e');
      return -1;
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateTransaction(IsarTransaction transaction) async {
    try {
      setLoading(true);
      await _db.updateTransaction(transaction);
      clearError();
    } catch (e) {
      setError('Failed to update transaction: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<bool> deleteTransaction(int id) async {
    try {
      setLoading(true);
      bool deleted = await _db.deleteTransaction(id);
      clearError();
      return deleted;
    } catch (e) {
      setError('Failed to delete transaction: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Budget Management
  Future<int> createBudget(IsarBudget budget) async {
    try {
      setLoading(true);
      int id = await _db.createBudget(budget);
      clearError();
      return id;
    } catch (e) {
      setError('Failed to create budget: $e');
      return -1;
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateBudget(IsarBudget budget) async {
    try {
      setLoading(true);
      await _db.updateBudget(budget);
      clearError();
    } catch (e) {
      setError('Failed to update budget: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<bool> deleteBudget(int id) async {
    try {
      setLoading(true);
      bool deleted = await _db.deleteBudget(id);
      clearError();
      return deleted;
    } catch (e) {
      setError('Failed to delete budget: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Analytics
  Future<double> getTotalIncome(int accountId, {DateTime? startDate, DateTime? endDate}) async {
    return await _db.getTotalIncomeByAccount(accountId, startDate: startDate, endDate: endDate);
  }

  Future<double> getTotalExpense(int accountId, {DateTime? startDate, DateTime? endDate}) async {
    return await _db.getTotalExpenseByAccount(accountId, startDate: startDate, endDate: endDate);
  }
}
