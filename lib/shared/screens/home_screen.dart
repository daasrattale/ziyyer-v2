import 'package:flutter/material.dart';
import 'package:ziyyer/widgets/home_header.dart';
import 'package:ziyyer/widgets/spending_category_section.dart';
import 'package:ziyyer/widgets/summary_card_row.dart';
import 'package:ziyyer/widgets/total_balance_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          HomeHeader(userName: "Super User", onNotificationTap: () {}),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TotalBalanceCard(income: 1000, payments: 400, totalBalance: 5498.87, currency: 'EUR', percentageChange: 44),
                  SummaryCardsRow(incomeAmount: 8762.34, paymentsAmount: 7654.89, incomeSources: 4),
                  SpendingCategorySection(),
                  SizedBox(height: screenSize.height * 0.1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
