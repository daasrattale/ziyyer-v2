import 'category_details.dart';

class BudgetDetails {
  const BudgetDetails({
    required this.id,
    required this.definedAmount,
    required this.realAmount,
    required this.allocatedAmount,
    required this.unallocatedAmount,
    required this.currency,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final double definedAmount;
  final double realAmount;
  final double allocatedAmount;
  final double unallocatedAmount;
  final String currency;
  final List<CategoryDetails> categories;
  final DateTime createdAt;
  final DateTime updatedAt;
}
