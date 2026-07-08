import 'package:ziyyer/shared/database/database.dart';

class PaymentPersistence {
  PaymentPersistence(this.db);

  final AppDatabase db;

  Future<void> create(List<PaymentTableCompanion> companions) async {
    if (companions.isEmpty) return;

    await db.batch((batch) {
      batch.insertAll(db.paymentTable, companions);
    });
  }

  Future<void> update(int budgetId, List<PaymentTableCompanion> companions) async {
    await (db.delete(db.paymentTable)..where((t) => t.budgetId.equals(budgetId))).go();

    if (companions.isEmpty) return;

    await db.batch((batch) {
      batch.insertAll(db.paymentTable, companions);
    });
  }

  Stream<List<Payment>> watch() {
    return db.select(db.paymentTable).watch();
  }
}
