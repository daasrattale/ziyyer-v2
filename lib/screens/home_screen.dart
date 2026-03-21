import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/buttons.dart';
import '../ui/card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ziyyer'), centerTitle: true, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Welcome Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome to Ziyyer', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Your personal finance app', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 32),

          // Card Section
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Balance', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text('\$5,250.00', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Buttons Section
          Text('Actions', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: Buttons.primaryButton(text: 'Add Transaction', onPressed: () {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Buttons.secondaryButton(text: 'View History', onPressed: () {}),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Buttons.secondaryButton(text: 'Settings', onPressed: () {}),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Navigation to Details
          SizedBox(
            width: double.infinity,
            child: Buttons.textButton(text: 'Go to Details', onPressed: () => context.push('/details')),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
