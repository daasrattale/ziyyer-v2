import 'package:isar/isar.dart';

import 'account_service.dart';
import 'budget_service.dart';
import 'transaction_service.dart';

/// Service Locator: Central access point for all business logic services
///
/// Provides singleton instances of all services initialized with the Isar database.
/// Use this to access services throughout the app instead of passing them individually.
class ServiceLocator {
  static late AccountService _accountService;
  static late TransactionService _transactionService;
  static late BudgetService _budgetService;

  /// Initialize all services with Isar database instance
  /// - Call this once during app startup after IsarDatabase.initialize()
  static void initialize(Isar isar) {
    _accountService = AccountService(isar);
    _transactionService = TransactionService(isar);
    _budgetService = BudgetService(isar);
  }

  /// Get Account Service singleton instance
  static AccountService get accounts => _accountService;

  /// Get Transaction Service singleton instance
  static TransactionService get transactions => _transactionService;

  /// Get Budget Service singleton instance
  static BudgetService get budgets => _budgetService;
}
