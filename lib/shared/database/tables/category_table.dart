import 'package:drift/drift.dart';

import 'budget_table.dart';

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

