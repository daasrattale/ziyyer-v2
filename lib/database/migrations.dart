/// Database Migrations for Ziyyer
/// 
/// Isar automatically handles schema versioning through the @collection
/// and @index annotations. When you modify the schema, Isar will:
/// 1. Detect the change
/// 2. Automatically migrate the data (adding/removing fields, indexes)
/// 3. Update the version number internally
///
/// Migration History:
///
/// V1.0 (Initial Release)
/// - Created IsarAccount collection with fields:
///   - name (unique index)
///   - accountType, balance, currency, initialBalance
///   - description, isActive, timestamps
/// - Created IsarTransaction collection with fields:
///   - accountId (foreign key, indexed)
///   - description, amount, type
///   - date (indexed), category, notes, timestamps
/// - Created IsarBudget collection with fields:
///   - category, limit, spent, period
///   - month (indexed), isActive, notes, timestamps
///
/// V1.1 (Upcoming)
/// - Add recurring transactions support (RecurringTransaction collection)
/// - Add goals tracking (FinancialGoal collection)
/// - Add tags/labels for transactions
///
/// To add a new migration:
/// 1. Modify the model (add/remove fields, indexes) in lib/models/
/// 2. Run: flutter pub run build_runner build --delete-conflicting-outputs
/// 3. Rebuild: flutter clean && flutter pub get && flutter run
/// 
/// Isar handles data migration automatically - existing data is preserved
/// and new fields are initialized with default values.
library;

class DbMigrations {
  // Add manual migration logic here if needed beyond Isar's auto-migration
  static Future<void> runMigrations() async {
    // Example: perform data transformations after Isar auto-migration
    // This would be called after IsarDatabase.initialize()
  }
}
