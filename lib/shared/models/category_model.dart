class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.definedAmount,
    required this.realAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final double definedAmount;
  final double realAmount;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  String toString() {
    return 'id=$id name=$name definedAmount=$definedAmount realAmount=$realAmount name=$name createdAt=$createdAt updatedAt=$updatedAt';
  }
}
