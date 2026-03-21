// ignore_for_file: avoid_print, unused_local_variable

import 'package:ziyyer/database/isar_database.dart';
import 'package:ziyyer/models/account.dart';
import 'package:ziyyer/models/budget.dart';
import 'package:ziyyer/models/transaction.dart';

/// Example usage of Isar database for Ziyyer
///
/// This file demonstrates how to use the reactive database
/// to create, read, update, and watch data

class DatabaseExamples {
  final _db = IsarDatabase();

  // Create a new account
  Future<void> createAccountExample() async {
    final account = IsarAccount(
      name: 'My Savings',
      accountType: 'savings',
      balance: 1000.0,
      currency: 'USD',
      initialBalance: 1000.0,
      description: 'Personal savings account',
    );

    int accountId = await _db.createAccount(account);
    print('Created account with ID: $accountId');
  }

  // Create a transaction
  Future<void> createTransactionExample() async {
    final transaction = IsarTransaction(
      accountId: 1, // Reference to account ID
      description: 'Grocery shopping',
      amount: 50.0,
      type: 'expense', // 'income' or 'expense'
      date: DateTime.now(),
      category: 'Food',
      notes: 'Weekly groceries',
    );

    int transactionId = await _db.createTransaction(transaction);
    print('Created transaction with ID: $transactionId');
  }

  // Create a budget
  Future<void> createBudgetExample() async {
    final budget = IsarBudget(category: 'Food', limit: 300.0, period: 'monthly', month: DateTime.now(), notes: 'Monthly food budget');

    int budgetId = await _db.createBudget(budget);
    print('Created budget with ID: $budgetId');
  }

  // Watch all accounts (reactive - updates automatically)
  Future<void> watchAccountsExample() async {
    _db.watchAllAccounts().listen((accounts) {
      print('Accounts changed: ${accounts.length} accounts');
      for (final account in accounts) {
        print('  - ${account.name}: \$${account.balance}');
      }
    });
  }

  // Watch transactions for a specific account
  Future<void> watchTransactionsExample() async {
    int accountId = 1;
    _db.watchTransactionsByAccount(accountId).listen((transactions) {
      print('Transactions for account $accountId: ${transactions.length}');
      for (final tx in transactions) {
        print('  - ${tx.description}: \$${tx.amount} (${tx.type})');
      }
    });
  }

  // Get transactions in a date range
  Future<void> getTransactionsByDateRangeExample() async {
    final startDate = DateTime(2024, 1, 1);
    final endDate = DateTime(2024, 1, 31);

    final transactions = await _db.getTransactionsByDateRange(startDate, endDate);
    print('Transactions in January 2024: ${transactions.length}');
  }

  // Calculate total income and expenses
  Future<void> calculateFinancialsExample() async {
    int accountId = 1;

    final totalIncome = await _db.getTotalIncomeByAccount(accountId);
    final totalExpense = await _db.getTotalExpenseByAccount(accountId);
    final balance = totalIncome - totalExpense;

    print('Income: \$$totalIncome');
    print('Expenses: \$$totalExpense');
    print('Balance: \$$balance');
  }

  // Update an account balance
  Future<void> updateAccountExample() async {
    final account = await _db.getAccount(1);
    if (account != null) {
      account.balance = 1500.0;
      account.updatedAt = DateTime.now();
      await _db.updateAccount(account);
      print('Updated account balance to \$${account.balance}');
    }
  }

  // Delete a transaction
  Future<void> deleteTransactionExample() async {
    bool deleted = await _db.deleteTransaction(1);
    if (deleted) {
      print('Transaction deleted successfully');
    }
  }

  // Watch active budgets
  Future<void> watchBudgetsExample() async {
    _db.watchActiveBudgets().listen((budgets) {
      print('Active budgets: ${budgets.length}');
      for (final budget in budgets) {
        final percentage = (budget.percentageUsed * 100).toStringAsFixed(1);
        print('  - ${budget.category}: \$${budget.spent}/\$${budget.limit} ($percentage%)');
      }
    });
  }

  // Seed database with sample data
  Future<void> seedDatabaseExample() async {
    // Create accounts
    final savingsAccount = IsarAccount(name: 'Savings', accountType: 'savings', balance: 5000.0, currency: 'USD', initialBalance: 5000.0);

    final checkingAccount = IsarAccount(name: 'Checking', accountType: 'checking', balance: 2500.0, currency: 'USD', initialBalance: 2500.0);

    int savingsId = await _db.createAccount(savingsAccount);
    int checkingId = await _db.createAccount(checkingAccount);

    // Create sample transactions
    final transactions = [
      IsarTransaction(
        accountId: checkingId,
        description: 'Salary',
        amount: 3000.0,
        type: 'income',
        date: DateTime.now().subtract(const Duration(days: 5)),
        category: 'Salary',
      ),
      IsarTransaction(
        accountId: checkingId,
        description: 'Rent',
        amount: 1200.0,
        type: 'expense',
        date: DateTime.now().subtract(const Duration(days: 3)),
        category: 'Housing',
      ),
      IsarTransaction(
        accountId: checkingId,
        description: 'Groceries',
        amount: 150.0,
        type: 'expense',
        date: DateTime.now().subtract(const Duration(days: 1)),
        category: 'Food',
      ),
    ];

    for (final tx in transactions) {
      await _db.createTransaction(tx);
    }

    // Create sample budgets
    final budgets = [
      IsarBudget(category: 'Food', limit: 300.0, period: 'monthly', month: DateTime.now()),
      IsarBudget(category: 'Entertainment', limit: 200.0, period: 'monthly', month: DateTime.now()),
    ];

    for (final budget in budgets) {
      await _db.createBudget(budget);
    }

    print('Database seeded with sample data');
  }
}
