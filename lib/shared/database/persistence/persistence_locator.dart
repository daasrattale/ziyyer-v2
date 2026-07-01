import 'package:ziyyer/shared/database/database.dart';
import 'package:ziyyer/shared/database/persistence/budget_persistence.dart';
import 'package:ziyyer/shared/database/persistence/category_persistence.dart';
import 'package:ziyyer/shared/database/persistence/transaction_persistence.dart';

class PersistenceLocator {
  static late BudgetPersistence _budgetPersistence;
  static late CategoryPersistence _categoryPersistence;
  static late TransactionPersistence _transactionPersistence;

  static void initialize(AppDatabase db) {
    _budgetPersistence = BudgetPersistence(db);
    _categoryPersistence = CategoryPersistence(db);
    _transactionPersistence = TransactionPersistence(db);
  }

  // SINGLETON ACCESSORS
  static BudgetPersistence get budgetPersistence => _budgetPersistence;
  static CategoryPersistence get categoryPersistence => _categoryPersistence;
  static TransactionPersistence get transactionPersistence => _transactionPersistence;
}
