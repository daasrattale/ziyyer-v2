import 'package:go_router/go_router.dart';
import 'package:ziyyer/screens/details_screen.dart';
import 'package:ziyyer/screens/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(path: '/', name: 'home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/details', name: 'details', builder: (context, state) => const DetailsScreen()),
  ],
);
