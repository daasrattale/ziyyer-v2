import 'package:drift/drift.dart';

@DataClassName('Budget')
class BudgetTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get definedAmount => real()();
  TextColumn get currency => text()();
  BoolColumn get isSetup => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
