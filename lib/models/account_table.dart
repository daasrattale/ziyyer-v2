import 'package:drift/drift.dart';

/// Drift table for Account
/// Maps directly to SQLite 'accounts' table
@DataClassName('Account')
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
  TextColumn get accountType => text()(); // 'savings', 'checking', 'credit_card', etc.
  RealColumn get balance => real()();
  TextColumn get currency => text()(); // 'USD', 'EUR', etc.
  RealColumn get initialBalance => real()();

  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

