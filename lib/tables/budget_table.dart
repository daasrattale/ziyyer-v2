import 'package:drift/drift.dart';


@DataClassName('Budget')
class BudgetTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get definedAmount => real()();
  RealColumn get realAmount => real().withDefault(const Constant(0))();
  TextColumn get currency => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

