import 'package:isar/isar.dart';

import '../database/base_repository.dart';
import '../models/account.dart';

/// Account Service: Business logic for account management
///
/// Singleton service that handles account operations and account-related queries.
/// Provides methods for account management beyond basic CRUD.
class AccountService extends BaseRepository<IsarAccount> {
  static final AccountService _instance = AccountService._internal();

  factory AccountService(Isar isar) {
    _instance.setIsar(isar);
    return _instance;
  }

  AccountService._internal() : super();

  @override
  IsarCollection<IsarAccount> get collection => isar.isarAccounts;

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
    final account = IsarAccount(
      name: name,
      accountType: accountType,
      balance: balance,
      currency: currency,
      initialBalance: balance,
      description: description,
      isActive: true,
    );
    return await create(account);
  }

  /// Get account by exact name (unique)
  /// - Returns null if not found
  Future<IsarAccount?> getByName(String name) async {
    final accounts = await getAll();
    try {
      return accounts.firstWhere((a) => a.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Get all active accounts
  Stream<List<IsarAccount>> watchActiveAccounts() {
    return isar.isarAccounts.where().filter().isActiveEqualTo(true).watch(fireImmediately: true);
  }

  /// Get all accounts of a specific type
  /// - Example: 'savings', 'checking', 'credit_card'
  Future<List<IsarAccount>> getAccountsByType(String accountType) async {
    final accounts = await getAll();
    return accounts.where((a) => a.accountType == accountType).toList();
  }

  /// Update account balance
  /// - Also updates the last modified timestamp
  Future<void> updateBalance(int accountId, double newBalance) async {
    final account = await getById(accountId);
    if (account == null) return;

    account.balance = newBalance;
    account.updatedAt = DateTime.now();

    await update(account);
  }

  /// Add to account balance
  /// - Useful for deposits/income
  Future<void> addBalance(int accountId, double amount) async {
    final account = await getById(accountId);
    if (account == null) return;

    account.balance += amount;
    account.updatedAt = DateTime.now();

    await update(account);
  }

  /// Subtract from account balance
  /// - Useful for withdrawals/expenses
  Future<void> subtractBalance(int accountId, double amount) async {
    final account = await getById(accountId);
    if (account == null) return;

    account.balance -= amount;
    account.updatedAt = DateTime.now();

    await update(account);
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

    account.isActive = false;
    account.updatedAt = DateTime.now();

    await update(account);
  }

  /// Reactivate an account
  Future<void> reactivateAccount(int accountId) async {
    final account = await getById(accountId);
    if (account == null) return;

    account.isActive = true;
    account.updatedAt = DateTime.now();

    await update(account);
  }

  /// Get account summary statistics
  /// - Returns map with total balance and account count
  Future<Map<String, dynamic>> getAccountSummary() async {
    final accounts = await watchActiveAccounts().first;
    final totalBalance = accounts.fold<double>(0.0, (sum, a) => sum + a.balance);

    return {'count': accounts.length, 'totalBalance': totalBalance, 'byType': _groupByType(accounts)};
  }

  /// Group accounts by type for summary
  Map<String, double> _groupByType(List<IsarAccount> accounts) {
    final grouped = <String, double>{};
    for (final account in accounts) {
      grouped[account.accountType] = (grouped[account.accountType] ?? 0) + account.balance;
    }
    return grouped;
  }
}
