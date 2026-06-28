import 'package:ziyyer/database/database.dart';

class BudgetWithCategories {
  const BudgetWithCategories({required this.budget, required this.categories});

  final Budget budget;
  final List<Category> categories;
}
