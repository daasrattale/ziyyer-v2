import 'package:go_router/go_router.dart';
import 'package:ziyyer/screens/add_expense_screen.dart';
import 'package:ziyyer/screens/backbone_screen.dart';
import 'package:ziyyer/screens/history_screen.dart';
import 'package:ziyyer/screens/home_screen.dart';
import 'package:ziyyer/screens/insights_screen.dart';
import 'package:ziyyer/screens/wallet_screen.dart';

final GoRouter appRouter = GoRouter(
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
            routes: [GoRoute(path: '/wallet', name: 'wallet', builder: (context, state) => const WalletScreen())],
          ),
        StatefulShellBranch(
            routes: [GoRoute(path: '/add-expense', name: 'add-expense', builder: (context, state) => const AddExpenseScreen())],
          ),
      ],
    ),
  ],
);
