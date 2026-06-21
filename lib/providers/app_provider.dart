import 'package:flutter/material.dart';
import 'package:ziyyer/database/database.dart';
import 'package:ziyyer/services/service_locator.dart';

class AppProvider with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';

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
  Future<int> createAccount({
    required String name,
    required String accountType,
    required double balance,
    required String currency,
    String? description,
  }) async {
    try {
      setLoading(true);
      int id = await ServiceLocator.accounts.createAccount(
        name: name,
        accountType: accountType,
        balance: balance,
        currency: currency,
        description: description,
      );
      clearError();
      return id;
    } catch (e) {
      setError('Failed to create account: $e');
      return -1;
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateAccount(Account account) async {
    try {
      setLoading(true);
      await ServiceLocator.accounts.update(account);
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
      int deleted = await ServiceLocator.accounts.delete(id);
      clearError();
      return deleted > 0;
    } catch (e) {
      setError('Failed to delete account: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Reactive Streams
  Stream<List<Account>> get accountsStream => ServiceLocator.accounts.watchAll();

  Stream<List<Transaction>> getTransactionsStream(int accountId) {
    return ServiceLocator.transactions.watchTransactionsByAccount(accountId);
  }

  Stream<List<Budget>> get budgetsStream => ServiceLocator.budgets.watchActiveBudgets();

  // Transaction Management
  Future<int> createTransaction({
    required int accountId,
    required String description,
    required double amount,
    required String type,
    required DateTime date,
    String? category,
    String? notes,
  }) async {
    try {
      setLoading(true);
      int id = await ServiceLocator.transactions.createTransaction(
        accountId: accountId,
        description: description,
        amount: amount,
        type: type,
        date: date,
        category: category,
        notes: notes,
      );
      clearError();
      return id;
    } catch (e) {
      setError('Failed to create transaction: $e');
      return -1;
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    try {
      setLoading(true);
      await ServiceLocator.transactions.update(transaction);
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
      int deleted = await ServiceLocator.transactions.delete(id);
      clearError();
      return deleted > 0;
    } catch (e) {
      setError('Failed to delete transaction: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Budget Management
  Future<int> createBudget({
    required String category,
    required double limit,
    required String period,
  }) async {
    try {
      setLoading(true);
      int id = await ServiceLocator.budgets.createBudget(
        category: category,
        limit: limit,
        period: period,
      );
      clearError();
      return id;
    } catch (e) {
      setError('Failed to create budget: $e');
      return -1;
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateBudget(Budget budget) async {
    try {
      setLoading(true);
      await ServiceLocator.budgets.update(budget);
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
      int deleted = await ServiceLocator.budgets.delete(id);
      clearError();
      return deleted > 0;
    } catch (e) {
      setError('Failed to delete budget: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  // Analytics
  Future<double> getTotalIncome(int accountId, {DateTime? startDate, DateTime? endDate}) async {
    return await ServiceLocator.transactions.getTotalIncome(accountId, start: startDate, end: endDate);
  }

  Future<double> getTotalExpense(int accountId, {DateTime? startDate, DateTime? endDate}) async {
    return await ServiceLocator.transactions.getTotalExpense(accountId, start: startDate, end: endDate);
  }
}
