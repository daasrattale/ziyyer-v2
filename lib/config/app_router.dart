import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ziyyer/shared/screens/add_expense_screen.dart';
import 'package:ziyyer/shared/screens/backbone_screen.dart';
import 'package:ziyyer/shared/screens/budget_screen.dart';
import 'package:ziyyer/shared/screens/history_screen.dart';
import 'package:ziyyer/shared/screens/home_screen.dart';
import 'package:ziyyer/shared/screens/insights_screen.dart';
import 'package:ziyyer/shared/screens/transaction_details_screen.dart';
import 'package:ziyyer/shared/screens/transactions_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => BackboneScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/', name: 'home', builder: (context, state) => const HomeScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/history', name: 'history', builder: (context, state) => const HistoryScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/insights', name: 'insights', builder: (context, state) => const InsightsScreen())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/add-expense', name: 'add-expense', builder: (context, state) => const AddExpenseScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/budget', name: 'budget', builder: (context, state) => const BudgetScreen())],
        ),
      ],
    ),

    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/transactions',
      name: 'transactions',
      builder: (context, state) {
        final args = state.extra as TransactionsScreenArgs;

        return TransactionsScreen(args: args);
      },
    ),

    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/transaction-details',
      name: 'transaction-details',
      builder: (context, state) {
        final args = state.extra as TransactionsDetailsScreenArgs;
        return TransactionsDetailsScreen(args: args);
      },
    ),
  ],
);
