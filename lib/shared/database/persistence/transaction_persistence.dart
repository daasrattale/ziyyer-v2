import 'package:ziyyer/shared/database/database.dart';

class TransactionPersistence {
  TransactionPersistence(this.db);

  final AppDatabase db;

  Future<void> creatAlle(List<TransactionTableCompanion> companions) async {
    if (companions.isEmpty) return;

    await db.batch((batch) {
      batch.insertAll(db.transactionTable, companions);
    });
  }

  Future<void> create(TransactionTableCompanion companion) async {
    await db.into(db.transactionTable).insert(companion);
  }

  Future<void> update(List<int> categoryIds, List<TransactionTableCompanion> companions) async {
    if (categoryIds.isNotEmpty) {
      await (db.delete(db.transactionTable)..where((t) => t.categoryId.isIn(categoryIds))).go();
    }

    if (companions.isEmpty) return;

    await db.batch((batch) {
      batch.insertAll(db.transactionTable, companions);
    });
  }

  Stream<List<Transaction>> watch() {
    return db.select(db.transactionTable).watch();
  }
}
