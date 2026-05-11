import 'package:isar_community/isar.dart';

/// Generic CRUD operations for Isar collections
///
/// Provides standardized methods for Create, Read, Update, Delete operations
/// to reduce boilerplate code and maintain consistency across services.
abstract class BaseRepository<T> {
  late Isar isar;

  BaseRepository();

  /// Initialize repository with Isar instance
  void setIsar(Isar isar) {
    this.isar = isar;
  }

  /// Get the collection for this repository type
  IsarCollection<T> get collection;

  /// Create: Insert or update an object
  /// Returns the ID of the created/updated object
  Future<int> create(T object) async {
    return await isar.writeTxn(() => collection.put(object));
  }

  /// Read: Get object by ID
  Future<T?> getById(int id) async {
    return await collection.get(id);
  }

  /// Read: Get all objects
  Future<List<T>> getAll() async {
    return await collection.where().findAll();
  }

  /// Update: Update an existing object
  Future<void> update(T object) async {
    await isar.writeTxn(() => collection.put(object));
  }

  /// Delete: Remove object by ID
  Future<bool> delete(int id) async {
    return await isar.writeTxn(() => collection.delete(id));
  }

  /// Watch: Stream of all objects (reactive)
  Stream<List<T>> watchAll() {
    return collection.where().watch(fireImmediately: true);
  }

  /// Watch: Stream of single object by ID (reactive)
  Stream<T?> watchById(int id) {
    return collection.watchObject(id, fireImmediately: true);
  }

  /// Delete all objects (useful for testing/reset)
  Future<void> deleteAll() async {
    await isar.writeTxn(() => collection.clear());
  }

  /// Count total objects
  Future<int> count() async {
    return await collection.where().count();
  }
}
