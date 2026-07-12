import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:ziyyer/shared/database/tables/budget_table.dart';
import 'package:ziyyer/shared/database/tables/category_table.dart';
import 'package:ziyyer/shared/database/tables/payment_table.dart';
import 'package:ziyyer/shared/database/tables/transaction_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [BudgetTable, CategoryTable, TransactionTable, PaymentTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(budgetTable, budgetTable.isSetup);
            // Migrate existing budgets: set isSetup = true if they have categories
            await customStatement('''
              UPDATE budget_table 
              SET is_setup = 1 
              WHERE id IN (SELECT DISTINCT budget_id FROM category_table)
            ''');
          }
          if (from < 3) {
            await m.addColumn(transactionTable, transactionTable.paymentMethod);
          }
        },
      );
}

LazyDatabase _openConnection() {
  final String databaseName = 'ziyyer.sqlite';

  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, databaseName));
    return NativeDatabase.createInBackground(file);
  });
}
