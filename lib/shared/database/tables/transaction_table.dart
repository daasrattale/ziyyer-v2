import 'package:drift/drift.dart';
import 'package:ziyyer/shared/database/tables/category_table.dart';

@DataClassName('Transaction')
class TransactionTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get categoryId => integer().references(CategoryTable, #id, onDelete: KeyAction.cascade)();

  RealColumn get amount => real()();

  DateTimeColumn get date => dateTime()();

  TextColumn get description => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
}
