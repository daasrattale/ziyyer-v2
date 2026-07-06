import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_router.dart';
import 'package:ziyyer/shared/database/database.dart';
import 'package:ziyyer/shared/database/persistence/persistence_locator.dart';
import 'package:ziyyer/shared/services/service_locator.dart';
import 'package:ziyyer/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  PersistenceLocator.initialize(database);
  ServiceLocator.initialize();
  runApp(const ZiyyerApp());
}

class ZiyyerApp extends StatelessWidget {
  const ZiyyerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        title: AppConstants.appName,
        routerConfig: appRouter,
        themeMode: ThemeMode.light,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
