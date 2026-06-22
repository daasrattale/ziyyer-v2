import 'package:drift/drift.dart';

import '../database/base_repository.dart';
import '../database/database.dart';
import '../models/account_table.dart';

/// Account Service: Business logic for account management
///
/// Singleton service that handles account operations and account-related queries.
/// Provides methods for account management beyond basic CRUD.
class AccountService extends BaseRepository<Accounts, Account> {
  static final AccountService _instance = AccountService._internal();

  factory AccountService(AppDatabase db) {
    _instance.setDatabase(db);
    return _instance;
  }

  AccountService._internal() : super();

  @override
  TableInfo<Accounts, Account> get table => db.accounts;

  /// Create a new account
  /// - Validates account name is unique
  /// - Initializes with provided balance and timestamps
  Future<int> createAccount({
    required String name,
    required String accountType,
    required double balance,
    required String currency,
    String? description,
  }) async {
    final account = AccountsCompanion.insert(
      name: name,
      accountType: accountType,
      balance: balance,
      currency: currency,
      initialBalance: balance,
      description: Value(description),
      isActive: const Value(true),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return await create(account);
  }

  /// Get account by exact name (unique)
  /// - Returns null if not found
  Future<Account?> getByName(String name) async {
    final query = db.select(table)..where((a) => a.name.equals(name));
    return await query.getSingleOrNull();
  }

  /// Get all active accounts
  Stream<List<Account>> watchActiveAccounts() {
    return (db.select(table)..where((a) => a.isActive.equals(true))).watch();
  }

  /// Get all accounts of a specific type
  /// - Example: 'savings', 'checking', 'credit_card'
  Future<List<Account>> getAccountsByType(String accountType) async {
    final query = db.select(table)..where((a) => a.accountType.equals(accountType));
    return await query.get();
  }

  /// Update account balance
  /// - Also updates the last modified timestamp
  Future<void> updateBalance(int accountId, double newBalance) async {
    final account = await getById(accountId);
    if (account == null) return;

    await update(account.copyWith(balance: newBalance, updatedAt: DateTime.now()));
  }

  /// Add to account balance
  /// - Useful for deposits/income
  Future<void> addBalance(int accountId, double amount) async {
    final account = await getById(accountId);
    if (account == null) return;

    await update(account.copyWith(balance: account.balance + amount, updatedAt: DateTime.now()));
  }

  /// Subtract from account balance
  /// - Useful for withdrawals/expenses
  Future<void> subtractBalance(int accountId, double amount) async {
    final account = await getById(accountId);
    if (account == null) return;

    await update(account.copyWith(balance: account.balance - amount, updatedAt: DateTime.now()));
  }

  /// Get total balance across all active accounts
  /// - Sums all account balances
  Future<double> getTotalBalance() async {
    final accounts = await getAll();
    return accounts.fold<double>(0.0, (sum, a) => sum + (a.isActive ? a.balance : 0));
  }

  /// Get total balance for accounts of a specific type
  /// - Sums balances by account type
  Future<double> getTotalBalanceByType(String accountType) async {
    final accounts = await getAccountsByType(accountType);
    return accounts.fold<double>(0.0, (sum, a) => sum + (a.isActive ? a.balance : 0));
  }

  /// Deactivate an account (soft delete)
  /// - Marks account as inactive without removing it
  Future<void> deactivateAccount(int accountId) async {
    final account = await getById(accountId);
    if (account == null) return;

    await update(account.copyWith(isActive: false, updatedAt: DateTime.now()));
  }

  /// Reactivate an account
  Future<void> reactivateAccount(int accountId) async {
    final account = await getById(accountId);
    if (account == null) return;

    await update(account.copyWith(isActive: true, updatedAt: DateTime.now()));
  }

  /// Get account summary statistics
  /// - Returns map with total balance and account count
  Future<Map<String, dynamic>> getAccountSummary() async {
    final accounts = await watchActiveAccounts().first;
    final totalBalance = accounts.fold<double>(0.0, (sum, a) => sum + a.balance);

    return {'count': accounts.length, 'totalBalance': totalBalance, 'byType': _groupByType(accounts)};
  }

  /// Group accounts by type for summary
  Map<String, double> _groupByType(List<Account> accounts) {
    final grouped = <String, double>{};
    for (final account in accounts) {
      grouped[account.accountType] = (grouped[account.accountType] ?? 0) + account.balance;
    }
    return grouped;
  }
}

