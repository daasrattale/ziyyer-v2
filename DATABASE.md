# Ziyyer Database Architecture

## Overview

Ziyyer uses **drift** (formerly moor) — a reactive SQLite ORM for Dart/Flutter. Schema is declared in Dart classes and code-generated via `build_runner`.

### Why drift?

- **Reactive**: `.watch()` returns `Stream<List<T>>` — UI rebuilds automatically on data changes
- **Type-safe**: Full Dart type support, no raw SQL strings
- **Compile-time checks**: Drift validates queries at build time via `build_runner`
- **Migration-friendly**: Schema versioning with manual migration steps
- **SQLite-native**: Embedded, no separate server

## Tables

### 1. **budget_table**

File: `lib/shared/database/tables/budget_table.dart`
Generated type: `Budget` (via `@DataClassName('Budget')`)
Table name in SQL: `budget_table`

```dart
@DataClassName('Budget')
class BudgetTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get definedAmount => real()();
  TextColumn get currency => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
```

| Dart column | SQL column | Type | Constraints |
|---|---|---|---|
| `id` | `id` | `INTEGER` | `PRIMARY KEY AUTOINCREMENT` |
| `definedAmount` | `defined_amount` | `REAL` | `NOT NULL` |
| `currency` | `currency` | `TEXT` | `NOT NULL` |
| `createdAt` | `created_at` | `DATETIME` | `NOT NULL` |
| `updatedAt` | `updated_at` | `DATETIME` | `NOT NULL` |

### 2. **category_table**

File: `lib/shared/database/tables/category_table.dart`
Generated type: `Category` (via `@DataClassName('Category')`)
Table name in SQL: `category_table`

```dart
@DataClassName('Category')
class CategoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get budgetId => integer().references(BudgetTable, #id)();
  TextColumn get name => text()();
  RealColumn get definedAmount => real()();
  RealColumn get realAmount => real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
```

| Dart column | SQL column | Type | Constraints |
|---|---|---|---|
| `id` | `id` | `INTEGER` | `PRIMARY KEY AUTOINCREMENT` |
| `budgetId` | `budget_id` | `INTEGER` | `NOT NULL`, `REFERENCES budget_table(id)` |
| `name` | `name` | `TEXT` | `NOT NULL` |
| `definedAmount` | `defined_amount` | `REAL` | `NOT NULL` |
| `realAmount` | `real_amount` | `REAL` | `DEFAULT 0` |
| `createdAt` | `created_at` | `DATETIME` | `NOT NULL` |
| `updatedAt` | `updated_at` | `DATETIME` | `NOT NULL` |

### 3. **transaction_table**

File: `lib/shared/database/tables/transaction_table.dart`
Generated type: `Transaction` (via `@DataClassName('Transaction')`)
Table name in SQL: `transaction_table`

```dart
@DataClassName('Transaction')
class TransactionTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(CategoryTable, #id, onDelete: KeyAction.cascade)();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
```

| Dart column | SQL column | Type | Constraints |
|---|---|---|---|
| `id` | `id` | `INTEGER` | `PRIMARY KEY AUTOINCREMENT` |
| `categoryId` | `category_id` | `INTEGER` | `NOT NULL`, `REFERENCES category_table(id) ON DELETE CASCADE` |
| `amount` | `amount` | `REAL` | `NOT NULL` |
| `date` | `date` | `DATETIME` | `NOT NULL` |
| `description` | `description` | `TEXT` | `NULLABLE` |
| `createdAt` | `created_at` | `DATETIME` | `NOT NULL` |

### 4. **payment_table**

File: `lib/shared/database/tables/payment_table.dart`
Generated type: `Payment` (via `@DataClassName('Payment')`)
Table name in SQL: `payment_table`

```dart
@DataClassName('Payment')
class PaymentTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get budgetId => integer().references(BudgetTable, #id)();
  TextColumn get name => text()();
  RealColumn get amount => real()();
}
```

| Dart column | SQL column | Type | Constraints |
|---|---|---|---|
| `id` | `id` | `INTEGER` | `PRIMARY KEY AUTOINCREMENT` |
| `budgetId` | `budget_id` | `INTEGER` | `NOT NULL`, `REFERENCES budget_table(id)` |
| `name` | `name` | `TEXT` | `NOT NULL` |
| `amount` | `amount` | `REAL` | `NOT NULL` |

## Entity-Relationship Diagram

```
budget_table (1) ──< (N) category_table (1) ──< (N) transaction_table
     │
     └── (1) ──< (N) payment_table
```

- A `Budget` has many `Category`s and many `Payment`s.
- A `Category` has many `Transaction`s.
- Deleting a `Category` cascades to delete its `Transaction`s.

## Database Connection

File: `lib/shared/database/database.dart`

```dart
@DriftDatabase(tables: [BudgetTable, CategoryTable, TransactionTable, PaymentTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'ziyyer.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
```

- File: `ziyyer.sqlite` in the app's documents directory.
- `@DriftDatabase` annotation registers all tables.
- `build_runner` generates `database.g.dart` containing the `_$AppDatabase` base class and typed `DataClass` types (`Budget`, `Category`, `Transaction`, `Payment`).

## Generated Types & Companions

Each table produces:
- A **DataClass** (e.g., `Transaction`) — immutable, with `copyWith`, `toJson`/`fromJson`.
- A **Companion** (e.g., `TransactionTableCompanion`) — used for inserts/updates. Use `Companion.insert(...)` for required fields and `Value(...)` / `const Value.absent()` for optional fields.

### Companion Usage

```dart
// Insert
db.into(db.transactionTable).insert(
  TransactionTableCompanion.insert(
    categoryId: 1,
    amount: 29.99,
    date: DateTime.now(),
    createdAt: DateTime.now(),
  ),
);

// Update (partial)
(db.update(db.transactionTable)..where((t) => t.id.equals(1))).write(
  TransactionTableCompanion(
    amount: Value(39.99),
  ),
);
```

## Persistence Layer

File location: `lib/shared/database/persistence/`

Thin wrapper classes that encapsulate database operations. Each takes `AppDatabase` as a constructor parameter.

| Persistence class | File |
|---|---|
| `BudgetPersistence` | `budget_persistence.dart` |
| `CategoryPersistence` | `category_persistence.dart` |
| `TransactionPersistence` | `transaction_persistence.dart` |
| `PaymentPersistence` | `payment_persistence.dart` |

### Persistence Pattern

```dart
class TransactionPersistence {
  TransactionPersistence(this.db);
  final AppDatabase db;

  Future<void> create(TransactionTableCompanion companion) async {
    await db.into(db.transactionTable).insert(companion);
  }

  Future<int> deleteById(int id) async {
    return (db.delete(db.transactionTable)..where((t) => t.id.equals(id))).go();
  }

  Future<int> updateById(int id, TransactionTableCompanion companion) async {
    return (db.update(db.transactionTable)..where((t) => t.id.equals(id))).write(companion);
  }

  Stream<List<Transaction>> watch() {
    return db.select(db.transactionTable).watch();
  }
}
```

### PersistenceLocator

File: `lib/shared/database/persistence/persistence_locator.dart`

Static singleton locator, initialized at app startup in `main.dart`:

```dart
PersistenceLocator.initialize(AppDatabase());
```

Accessed globally:

```dart
PersistenceLocator.transactionPersistence.watch().listen(...);
```

## Reactive Queries

### Watching streams (real-time)

```dart
// Watch all transactions
PersistenceLocator.transactionPersistence.watch().listen((transactions) {
  // Called whenever transactions change
});

// Watch first budget (single or null)
BudgetPersistence(db).watch().listen((Budget? budget) {
  // Called when the budget changes
});
```

### One-time queries

```dart
import 'package:drift/drift.dart';

// Get by ID
final transaction = await (db.select(db.transactionTable)..where((t) => t.id.equals(1))).getSingleOrNull();

// Get filtered list
final results = await (db.select(db.transactionTable)..where((t) => t.categoryId.equals(3))).get();

// Custom filter by date range
final results = await (db.select(db.transactionTable)..where((t) => t.date.isBetween(start, end))).get();
```

### Delete cascade propagation

Drift is configured to cascade deletions from `category_table` to `transaction_table`. The `streamUpdateRules` in the generated code also propagate update notifications so that watchers on `transaction_table` are notified when a `category_table` row is deleted.

## Schema Migrations

Drift uses explicit schema versioning with manual migration steps.

### Adding a new column

```dart
// 1. Add the column to the table definition
class TransactionTable extends Table {
  // ... existing columns
  TextColumn get notes => text().nullable()();  // new column
}

// 2. Bump schema version and add migration
class AppDatabase extends _$AppDatabase {
  @override
  int get schemaVersion => 2;

  AppDatabase() : super(_openConnection());

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from == 1) {
          await m.addColumn(transactionTable, transactionTable.notes);
        }
      },
    );
  }
}
```

### 3. Regenerate codegen

```bash
dart run build_runner build --delete-conflicting-outputs
```

## CRUD Summary

| Operation | Method |
|---|---|
| **Create** | `db.into(db.table).insert(Companion.insert(...))` |
| **Batch create** | `db.batch((b) => b.insertAll(db.table, companions))` |
| **Read all** | `db.select(db.table).get()` |
| **Read one** | `(db.select(db.table)..where((t) => t.id.equals(id))).getSingleOrNull()` |
| **Update** | `(db.update(db.table)..where((t) => t.id.equals(id))).write(Companion(...))` |
| **Delete** | `(db.delete(db.table)..where((t) => t.id.equals(id))).go()` |
| **Watch** | `db.select(db.table).watch()` — returns `Stream<List<T>>` |

## Services Layer

File location: `lib/shared/services/`

Services combine data from multiple persistence sources and expose reactive models:

- `BudgetService` — merges `BudgetPersistence`, `CategoryPersistence`, and `PaymentPersistence` using `rxdart`'s `Rx.combineLatest3`
- `TransactionService` — wraps `TransactionPersistence` with higher-level `persist()`, `delete()`, `update()` methods
- `CategoryService` / `PaymentService` — stubs

Accessed via `ServiceLocator` (initialized in `main.dart`).

## Model Mapping

Drift-generated types (`Transaction`, `Category`, `Budget`, `Payment`) are converted to project models via `from...()` factory constructors:

```dart
factory TransactionModel.fromTransaction(Transaction transaction) {
  return TransactionModel(
    id: transaction.id,
    categoryId: transaction.categoryId,
    amount: transaction.amount,
    date: transaction.date,
    description: transaction.description,
    createdAt: transaction.createdAt,
  );
}
```

## Database Location

```
ziyyer.sqlite  →  getApplicationDocumentsDirectory()
```

- **iOS**: `<app container>/Documents/ziyyer.sqlite`
- **Android**: `/data/data/com.example.ziyyer/app_flutter/ziyyer.sqlite`

## Development

### Reset database

```dart
final dbFolder = await getApplicationDocumentsDirectory();
final file = File(p.join(dbFolder.path, 'ziyyer.sqlite'));
await file.delete();
```

### Regenerate codegen

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Raw SQL via drift (if needed)

```dart
await db.customSelect('SELECT * FROM transaction_table WHERE amount > ?', variables: [Variable.withDouble(100.0)]);
```

## References

- [Drift Documentation](https://drift.simonbinder.eu/)
- [Drift Dart API](https://pub.dev/packages/drift)
- [SQLite Documentation](https://www.sqlite.org/docs.html)
