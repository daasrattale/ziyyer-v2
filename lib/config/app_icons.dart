import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppIcons {
  static const IconData home = FeatherIcons.home;
  static const IconData history = Icons.history;
  static const IconData insights = FeatherIcons.pieChart;
  static const IconData budget = LucideIcons.piggyBank;
  static const IconData notification = FeatherIcons.bell;
  static const IconData add = FeatherIcons.plus;
  static const IconData coffee = FeatherIcons.coffee;
  static const IconData truck = FeatherIcons.truck;
  static const IconData shoppingBag = FeatherIcons.shoppingBag;
  static const IconData film = FeatherIcons.film;
  static const IconData trendingUp = FeatherIcons.trendingUp;
  static const IconData trendingDown = FeatherIcons.trendingDown;
  static const IconData arrowUpRight = FeatherIcons.arrowUpRight;
  static const IconData arrowDownRight = FeatherIcons.arrowDownRight;
  static const IconData arrowRight = LucideIcons.moveRight;
  static const IconData arrowLeft = LucideIcons.moveLeft;
  static const IconData check = LucideIcons.check;
  static const IconData receipt = LucideIcons.receiptText;
  static const IconData trash = LucideIcons.trash;
  static const IconData category = LucideIcons.squareStack;
  static const IconData x = LucideIcons.x;
  static const IconData edit = LucideIcons.pencil;
  static const IconData settings = LucideIcons.settings;
  static const IconData language = Icons.language;
  static const IconData money = LucideIcons.banknote;
  static const IconData description = LucideIcons.textAlignStart;
  static const IconData calendar = LucideIcons.calendar;
  static const IconData transaction = LucideIcons.arrowRightLeft;
  static const IconData plugZap = LucideIcons.plugZap;

  static const Map<String, IconData> supportedCategoriesIcons = {
    'other': category,
    'food': coffee,
    'groceries': shoppingBag,
    'shopping': shoppingBag,
    'housing': home,
    'rent': home,
    'electricity': plugZap,
    'elec': plugZap,
    'mortgage': home,
    'utilities': receipt,
    'utility': receipt,
    'subscriptions': film,
    'subscription': film,
    'health': receipt,
    'healthcare': receipt,
    'medical': receipt,
    'transportation': truck,
    'transport': truck,
    'travel': truck,
    'income': trendingUp,
    'salary': trendingUp,
    'investment': trendingUp,
    'expense': trendingDown,
    'entertainment': film,
    'bills': receipt,
    'savings': budget,
  };

  static IconData categoryIconFor(String? categoryName) {
    final normalized = categoryName?.trim().toLowerCase();
    return supportedCategoriesIcons[normalized] ?? category;
  }
}
