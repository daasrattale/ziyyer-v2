import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:ziyyer/shared/database/tables/budget_table.dart';
import 'package:ziyyer/shared/database/tables/category_table.dart';
import 'package:ziyyer/shared/database/tables/transaction_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [BudgetTable, CategoryTable, TransactionTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  final String databaseName = 'ziyyer.sqlite';

  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, databaseName));
    return NativeDatabase.createInBackground(file);
  });
}
