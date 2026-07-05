class PaymentModel {
  int? id;
  String name;
  double amount;

  PaymentModel({required this.id, required this.name, required this.amount});

  @override
  String toString() {
    return 'id=$id name=$name amount=$amount';
  }
}
