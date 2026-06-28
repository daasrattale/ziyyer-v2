# Ziyyer Database Architecture

## Overview

Ziyyer uses **Isar** as its primary database - a modern, reactive NoSQL database optimized for Flutter applications.

### Why Isar?

✅ **Reactive**: Streams automatically update UI when data changes
✅ **Fast**: Native compiled code, extremely performant
✅ **Simple**: No complex migrations or SQL
✅ **Type-safe**: Full Dart type support
✅ **Embedded**: No separate server needed
✅ **Automatic Versioning**: Schema changes are handled automatically

## Database Collections

### 1. **IsarAccount**

Represents bank accounts, wallets, or any money container.

```dart
@collection
class IsarAccount {
  Id? id;                          // Auto-generated ID
  String name;                     // Unique account name
  String accountType;              // 'savings', 'checking', 'credit_card'
  double balance;                  // Current balance
  String currency;                 // 'USD', 'EUR', etc.
  double initialBalance;           // Starting balance
  String? description;             // Optional notes
  bool isActive;                   // Soft delete support
  DateTime createdAt;              // Creation timestamp
  DateTime updatedAt;              // Last modified timestamp
}
```

**Indexes**: `name` (unique), `createdAt`

### 2. **IsarTransaction**

Records all financial transactions (income/expense).

```dart
@collection
class IsarTransaction {
  Id? id;                          // Auto-generated ID
  int accountId;                   // Foreign key to account
  String description;              // Transaction description
  double amount;                   // Transaction amount
  String type;                     // 'income' or 'expense'
  DateTime date;                   // Transaction date
  String? category;                // Optional category
  String? notes;                   // Optional notes
  DateTime createdAt;              // Creation timestamp
  DateTime updatedAt;              // Last modified timestamp
}
```

**Indexes**: `accountId`, `date`

### 3. **IsarBudget**

Tracks spending budgets and limits.

```dart
@collection
class IsarBudget {
  Id? id;                          // Auto-generated ID
  String category;                 // Budget category
  double limit;                    // Budget limit amount
  double spent;                    // Amount spent so far
  String period;                   // 'monthly', 'weekly', 'yearly'
  DateTime month;                  // Reference month (for filtering)
  bool isActive;                   // Status
  String? notes;                   // Optional notes
  DateTime createdAt;              // Creation timestamp
  DateTime updatedAt;              // Last modified timestamp
}
```

**Indexes**: `month`

## Schema Migrations

### How Isar Handles Migrations Automatically

Isar automatically detects schema changes and migrates data:

1. **Adding fields**: New fields are initialized with default values
2. **Removing fields**: Data is discarded (non-destructive for old data)
3. **Changing types**: Attempted conversion or field reset
4. **Adding indexes**: Indexes are rebuilt automatically
5. **Renaming fields**: Not directly supported; requires manual migration

### Manual Migration Example

If you need to do something like rename a field:

```dart
// In lib/database/migrations.dart

static Future<void> runMigrations() async {
  final db = IsarDatabase.isar;
  
  // Example: Rename 'title' to 'description'
  final transactions = await db.isarTransactions.where().findAll();
  await db.writeTxn(() async {
    for (var tx in transactions) {
      // Perform transformation
      tx.description = tx.description; // Already renamed in model
      await db.isarTransactions.put(tx);
    }
  });
}
```

### How to Add New Fields

1. **Update the model** in `lib/tables/`:

   ```dart
   @Index()
   String? newField; // Add field
   ```

2. **Rebuild the generated code**:

   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **That's it!** Isar handles the rest automatically

## Reactive Queries

### Watch Streams (Real-time Updates)

```dart
// Watch all accounts - updates whenever accounts change
_db.watchAllAccounts().listen((accounts) {
  setState(() => _accounts = accounts);
});

// Watch transactions for account 1
_db.watchTransactionsByAccount(1).listen((txs) {
  setState(() => _transactions = txs);
});

// Watch active budgets
_db.watchActiveBudgets().listen((budgets) {
  setState(() => _budgets = budgets);
});
```

### One-time Queries

```dart
// Get account by ID
IsarAccount? account = await _db.getAccount(1);

// Get all active accounts
List<IsarAccount> accounts = await _db.getAllAccounts();

// Get transactions in date range
List<IsarTransaction> txs = await _db.getTransactionsByDateRange(
  DateTime(2024, 1, 1),
  DateTime(2024, 1, 31),
);

// Calculate totals
double income = await _db.getTotalIncomeByAccount(1);
double expenses = await _db.getTotalExpenseByAccount(1);
```

## CRUD Operations

### Create

```dart
final account = IsarAccount(
  name: 'My Savings',
  accountType: 'savings',
  balance: 1000.0,
  currency: 'USD',
  initialBalance: 1000.0,
);

int id = await _db.createAccount(account);
```

### Read

```dart
IsarAccount? account = await _db.getAccount(id);
List<IsarAccount> all = await _db.getAllAccounts();
```

### Update

```dart
account.balance = 2000.0;
account.updatedAt = DateTime.now();
await _db.updateAccount(account);
```

### Delete

```dart
bool deleted = await _db.deleteAccount(id);
```

## Database Service Structure

Location: `lib/database/isar_database.dart`

```dart
class IsarDatabase {
  static final IsarDatabase _instance = IsarDatabase._internal();
  static late Isar _isar;

  // Singleton pattern
  factory IsarDatabase() => _instance;
  IsarDatabase._internal();

  // Initialize once at app startup
  static Future<void> initialize() async {
    // Opens database in app documents directory
  }

  // Account methods
  Future<int> createAccount(IsarAccount account)
  Future<void> updateAccount(IsarAccount account)
  Future<bool> deleteAccount(int id)
  Stream<List<IsarAccount>> watchAllAccounts()
  Future<IsarAccount?> getAccount(int id)
  Future<List<IsarAccount>> getAllAccounts()

  // Transaction methods
  Future<int> createTransaction(IsarTransaction transaction)
  Future<void> updateTransaction(IsarTransaction transaction)
  Future<bool> deleteTransaction(int id)
  Stream<List<IsarTransaction>> watchTransactionsByAccount(int accountId)
  Future<List<IsarTransaction>> getTransactionsByDateRange(start, end)
  Future<double> getTotalIncomeByAccount(int accountId, {dates})
  Future<double> getTotalExpenseByAccount(int accountId, {dates})

  // Budget methods
  Future<int> createBudget(IsarBudget budget)
  Future<void> updateBudget(IsarBudget budget)
  Future<bool> deleteBudget(int id)
  Stream<List<IsarBudget>> watchAllBudgets()
  Stream<List<IsarBudget>> watchActiveBudgets()
  Future<List<IsarBudget>> getAllBudgets()

  // Utility
  Future<void> clear()     // Reset entire database
  Future<void> close()     // Cleanup on app exit
}
```

## App Provider Integration

Location: `lib/providers/app_provider.dart`

Wraps database operations with loading/error state management:

```dart
class AppProvider with ChangeNotifier {
  final _db = IsarDatabase();
  bool _isLoading = false;
  String _errorMessage = '';

  // Exposed streams for widgets
  Stream<List<IsarAccount>> get accountsStream => _db.watchAllAccounts();
  Stream<List<IsarBudget>> get budgetsStream => _db.watchActiveBudgets();

  // Operations with error handling
  Future<int> createAccount(IsarAccount account) async {
    try {
      setLoading(true);
      int id = await _db.createAccount(account);
      clearError();
      return id;
    } catch (e) {
      setError('Failed: $e');
      return -1;
    }
  }
}
```

## Using in Widgets

### Simple StreamBuilder Pattern

```dart
Widget build(BuildContext context) {
  final provider = Provider.of<AppProvider>(context);
  
  return StreamBuilder<List<IsarAccount>>(
    stream: provider.accountsStream,
    builder: (context, snapshot) {
      if (!snapshot.hasData) return CircularProgressIndicator();
      return ListView(
        children: snapshot.data!.map((account) => 
          ListTile(title: Text(account.name))
        ).toList(),
      );
    },
  );
}
```

## Performance Considerations

1. **Indexes**: Applied to frequently queried fields (`accountId`, `date`, `month`)
2. **Lazy Loading**: Queries only load what's needed
3. **Transactions**: Write operations are atomic via `writeTxn()`
4. **Filtering**: Server-side filtering is more efficient than client-side

## Database Location

Database file is stored in the app's documents directory:

- **iOS**: `~/Library/Preferences/`
- **Android**: `/data/data/com.example.ziyyer/`

Backup and restore are straightforward - just copy the database files.

## Development Helpers

### Reset Database

```dart
IsarDatabase db = IsarDatabase();
await db.clear(); // Remove all data
```

### Seed Data

See `lib/database/database_examples.dart` for sample seeding code.

### Monitor Database

```bash
# View Isar inspector (requires isar_inspector package)
flutter pub add dev:isar_inspector
```

## Future Enhancements

- [ ] Add recurring transactions support
- [ ] Add financial goals tracking
- [ ] Add tags/labels for better categorization
- [ ] Add change logs for audit trail
- [ ] Add backup/restore functionality
- [ ] Add data encryption

## References

- [Isar Documentation](https://isar.dev)
- [Isar Queries](https://isar.dev/queries.html)
- [Isar Reactive](https://isar.dev/watching.html)
