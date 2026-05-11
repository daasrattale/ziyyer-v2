import 'package:go_router/go_router.dart';
import 'package:ziyyer/screens/backbone_screen.dart';
import 'package:ziyyer/screens/details_screen.dart';
import 'package:ziyyer/screens/home_screen.dart';

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
          routes: [GoRoute(path: '/details', name: 'details', builder: (context, state) => const DetailsScreen())],
        ),
      ],
    ),
  ],
);
