import 'package:isar/isar.dart';

part 'transaction.g.dart';

@collection
class IsarTransaction {
  Id? id;

  late int accountId; // Foreign key to account

  late String description;
  late double amount;
  late String type; // 'income' or 'expense'

  late DateTime date;

  String? category;
  String? notes;

  late DateTime createdAt;
  late DateTime updatedAt;

  IsarTransaction({
    this.id,
    required this.accountId,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
    this.category,
    this.notes,
  }) : createdAt = DateTime.now(),
       updatedAt = DateTime.now();
}
