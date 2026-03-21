import 'package:flutter/material.dart';
import 'package:ziyyer/config/app_router.dart';
import 'package:ziyyer/config/theme.dart';
import 'package:ziyyer/database/isar_database.dart';
import 'package:ziyyer/services/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarDatabase.initialize();
  ServiceLocator.initialize(IsarDatabase.isar);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ziyyer',
      routerConfig: appRouter,
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      debugShowCheckedModeBanner: false,
    );
  }
}
