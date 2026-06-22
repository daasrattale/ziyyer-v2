import 'package:drift/drift.dart';

/// Drift table for Budget
/// Maps directly to SQLite 'budgets' table
@DataClassName('Budget')
class Budgets extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get category => text()();
  RealColumn get limit => real()();
  RealColumn get spent => real().withDefault(const Constant(0))();
  TextColumn get period => text()(); // 'monthly', 'weekly', 'yearly'

  DateTimeColumn get month => dateTime()(); // For filtering by month

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

