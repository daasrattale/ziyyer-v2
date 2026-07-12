import 'package:ziyyer/shared/database/database.dart';

class TransactionModel {
  final int id;
  final int categoryId;
  final double amount;
  final DateTime date;
  final String? description;
  final String? paymentMethod;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.date,
    this.description,
    this.paymentMethod,
    required this.createdAt,
  });

  factory TransactionModel.init() {
    return TransactionModel(
      id: 0,
      categoryId: 0,
      amount: 0,
      date: DateTime.now(),
      description: null,
      paymentMethod: null,
      createdAt: DateTime.now(),
    );
  }

  TransactionModel copyWith({
    int? id,
    int? categoryId,
    double? amount,
    DateTime? date,
    String? description,
    String? paymentMethod,
    DateTime? createdAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TransactionModel.fromTransaction(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      categoryId: transaction.categoryId,
      amount: transaction.amount,
      date: transaction.date,
      description: transaction.description,
      paymentMethod: transaction.paymentMethod,
      createdAt: transaction.createdAt,
    );
  }
}
