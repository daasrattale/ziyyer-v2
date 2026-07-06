import 'package:drift/drift.dart';
import 'package:ziyyer/shared/database/tables/budget_table.dart';

@DataClassName('Payment')
class PaymentTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get budgetId => integer().references(BudgetTable, #id)();
  TextColumn get name => text()();
  RealColumn get amount => real()();
}
