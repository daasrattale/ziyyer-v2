import '../database/database.dart';
import 'account_service.dart';
import 'budget_service.dart';
import 'transaction_service.dart';

/// Service Locator: Central access point for all business logic services
///
/// Provides singleton instances of all services initialized with the Drift database.
/// Use this to access services throughout the app instead of passing them individually.
class ServiceLocator {
  static late AccountService _accountService;
  static late TransactionService _transactionService;
  static late BudgetService _budgetService;

  /// Initialize all services with Drift database instance
  /// - Call this once during app startup
  static void initialize(AppDatabase db) {
    _accountService = AccountService(db);
    _transactionService = TransactionService(db);
    _budgetService = BudgetService(db);
  }

  /// Get Account Service singleton instance
  static AccountService get accounts => _accountService;

  /// Get Transaction Service singleton instance
  static TransactionService get transactions => _transactionService;

  /// Get Budget Service singleton instance
  static BudgetService get budgets => _budgetService;
}
