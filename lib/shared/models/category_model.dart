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

  double get realAmount => transactions
      .where((transaction) => transaction.createdAt.month == DateTime.now().month)
      .fold<double>(0, (sum, transaction) => sum + transaction.amount);

  @override
  String toString() {
    return 'id=$id name=$name definedAmount=$definedAmount realAmount=$realAmount name=$name createdAt=$createdAt updatedAt=$updatedAt';
  }
}
