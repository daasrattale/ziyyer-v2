import 'package:isar_community/isar.dart';

part 'account.g.dart';

@collection
class IsarAccount {
  Id? id;

  late String name;

  late String accountType; // 'savings', 'checking', 'credit_card', etc.
  late double balance;
  late String currency; // 'USD', 'EUR', etc.
  late double initialBalance;

  String? description;
  bool isActive = true;

  late DateTime createdAt;
  late DateTime updatedAt;

  IsarAccount({
    this.id,
    required this.name,
    required this.accountType,
    required this.balance,
    required this.currency,
    required this.initialBalance,
    this.description,
    this.isActive = true,
  }) : createdAt = DateTime.now(),
       updatedAt = DateTime.now();
}
