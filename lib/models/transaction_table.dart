import 'package:drift/drift.dart';

/// Drift table for Transaction
/// Maps directly to SQLite 'transactions' table
@DataClassName('Transaction')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get accountId => integer()(); // Foreign key to accounts

  TextColumn get description => text()();
  RealColumn get amount => real()();
  TextColumn get type => text()(); // 'income' or 'expense'

  DateTimeColumn get date => dateTime()();

  TextColumn get category => text().nullable()();
  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<String> get customConstraints => [
    'FOREIGN KEY (account_id) REFERENCES accounts (id) ON DELETE CASCADE',
  ];
}

