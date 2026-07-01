class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.budgetId,
    required this.name,
    required this.definedAmount,
    required this.realAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int budgetId;
  final String name;
  final double definedAmount;
  final double realAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
}
