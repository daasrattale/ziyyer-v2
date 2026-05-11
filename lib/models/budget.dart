import 'package:isar_community/isar.dart';

part 'budget.g.dart';

@collection
class IsarBudget {
  Id? id;

  late String category;
  late double limit;
  late double spent = 0;
  late String period; // 'monthly', 'weekly', 'yearly'

  late DateTime month; // For filtering by month

  bool isActive = true;
  String? notes;

  late DateTime createdAt;
  late DateTime updatedAt;

  IsarBudget({this.id, required this.category, required this.limit, required this.period, required this.month, this.isActive = true, this.notes})
    : createdAt = DateTime.now(),
      updatedAt = DateTime.now();

  double get remainingBudget => limit - spent;
  double get percentageUsed => spent / limit;
}
