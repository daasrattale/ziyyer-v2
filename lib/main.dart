import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:toastification/toastification.dart';
import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/config/app_router.dart';
import 'package:ziyyer/l10n/app_localizations.dart';
import 'package:ziyyer/shared/database/database.dart';
import 'package:ziyyer/shared/database/persistence/persistence_locator.dart';
import 'package:ziyyer/shared/services/locale_provider.dart';
import 'package:ziyyer/shared/services/service_locator.dart';
import 'package:ziyyer/theme.dart';

void initializeDependencies() {
  final database = AppDatabase();
  PersistenceLocator.initialize(database);
  ServiceLocator.initialize();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  initializeDependencies();
  runApp(const ZiyyerApp());
}

class ZiyyerApp extends StatefulWidget {
  const ZiyyerApp({super.key});

  @override
  State<ZiyyerApp> createState() => _ZiyyerAppState();
}

class _ZiyyerAppState extends State<ZiyyerApp> {
  final LocaleProvider _localeProvider = LocaleProvider();
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(_localeProvider);
    _localeProvider.addListener(_onLocaleChanged);
  }

  @override
  void dispose() {
    _localeProvider.removeListener(_onLocaleChanged);
    _localeProvider.dispose();
    super.dispose();
  }

  void _onLocaleChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: ListenableBuilder(
        listenable: _localeProvider,
        builder: (context, child) {
          return MaterialApp.router(
            title: AppConstants.appName,
            routerConfig: _appRouter.appRouter,
            themeMode: ThemeMode.light,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            debugShowCheckedModeBanner: false,
            locale: _localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('fr'), Locale('es')],
          );
        },
      ),
    );
  }
}
