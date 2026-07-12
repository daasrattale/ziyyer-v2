import 'package:ziyyer/shared/models/transaction_model.dart';

class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.definedAmount,
    required this.transactions,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final double definedAmount;
  final List<TransactionModel> transactions;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel copyWith({
    int? id,
    String? name,
    double? definedAmount,
    List<TransactionModel>? transactions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      definedAmount: definedAmount ?? this.definedAmount,
      transactions: transactions ?? this.transactions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  double get realAmount {
    final now = DateTime.now();
    return transactions
        .where((t) => t.date.year == now.year && t.date.month == now.month)
        .fold<double>(0, (sum, t) => sum + t.amount);
  }

  @override
  String toString() {
    return 'id=$id name=$name definedAmount=$definedAmount realAmount=$realAmount name=$name createdAt=$createdAt updatedAt=$updatedAt';
  }
}
