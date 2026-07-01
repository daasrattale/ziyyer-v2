// import 'package:flutter/material.dart';

// enum BudgetSetupPeriod { weekly, monthly, yearly }

// class BudgetSetupCategoryDetails {
//   BudgetSetupCategoryDetails({
//     required this.key,
//     required this.name,
//     required this.label,
//     required this.description,
//     required this.icon,
//     this.selected = false,
//     this.amount = 0,
//   });

//   final String key;
//   final String name;
//   final String label;
//   final String description;
//   final IconData icon;
//   final bool selected;
//   final double amount;

//   BudgetSetupCategoryDetails copyWith({
//     String? key,
//     String? name,
//     String? label,
//     String? description,
//     IconData? icon,
//     bool? selected,
//     double? amount,
//   }) {
//     return BudgetSetupCategoryDetails(
//       key: key ?? this.key,
//       name: name ?? this.name,
//       label: label ?? this.label,
//       description: description ?? this.description,
//       icon: icon ?? this.icon,
//       selected: selected ?? this.selected,
//       amount: amount ?? this.amount,
//     );
//   }
// }

// class BudgetSetupResultDetails {
//   const BudgetSetupResultDetails({required this.totalAmount, required this.currency, required this.period, required this.categories});

//   final double totalAmount;
//   final String currency;
//   final BudgetSetupPeriod period;
//   final List<BudgetSetupCategoryDetails> categories;
// }

// class BudgetSetupResult {
//   const BudgetSetupResult({required this.totalAmount, required this.currency, required this.period, required this.categories});

//   final double totalAmount;
//   final String currency;
//   final BudgetSetupPeriod period;
//   final List<BudgetSetupCategory> categories;
// }
