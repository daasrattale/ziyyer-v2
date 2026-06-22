import 'package:drift/drift.dart';
import 'database.dart';

/// Generic CRUD operations for Drift tables
///
/// Provides standardized methods for Create, Read, Update, Delete operations
/// to reduce boilerplate code and maintain consistency across services.
abstract class BaseRepository<T extends Table, D> {
  late AppDatabase db;

  BaseRepository();

  /// Initialize repository with Database instance
  void setDatabase(AppDatabase db) {
    this.db = db;
  }

  /// Get the table/query for this repository type
  TableInfo<T, D> get table;

  /// Create: Insert or update an object
  /// Returns the ID of the created/updated object
  Future<int> create(Insertable<D> object) async {
    return await db.into(table as dynamic).insert(object);
  }

  /// Read: Get object by ID
  Future<D?> getById(int id) async {
    final query = db.select(table as dynamic)..where((t) => (t as dynamic).id.equals(id));
    return await query.getSingleOrNull() as D?;
  }

  /// Read: Get all objects
  Future<List<D>> getAll() async {
    final results = await db.select(table as dynamic).get();
    return results.cast<D>();
  }

  /// Update: Update an existing object
  Future<bool> update(Insertable<D> object) async {
    return await db.update(table as dynamic).replace(object);
  }

  /// Delete: Remove object by ID
  Future<int> delete(int id) async {
    return await (db.delete(table as dynamic)..where((t) => (t as dynamic).id.equals(id))).go();
  }

  /// Watch: Stream of all objects (reactive)
  Stream<List<D>> watchAll() {
    return db.select(table as dynamic).watch().map((list) => list.cast<D>());
  }

  /// Watch: Stream of single object by ID (reactive)
  Stream<D?> watchById(int id) {
    return (db.select(table as dynamic)..where((t) => (t as dynamic).id.equals(id))).watchSingleOrNull().map((item) => item as D?);
  }

  /// Delete all objects (useful for testing/reset)
  Future<void> deleteAll() async {
    await db.delete(table as dynamic).go();
  }

  /// Count total objects
  Future<int> count() async {
    final countExp = table.columnsByName['id']?.count() ?? countAll();
    final query = db.selectOnly(table as dynamic)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }
}
