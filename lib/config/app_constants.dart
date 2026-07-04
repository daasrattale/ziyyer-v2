import 'package:ziyyer/shared/models/currency_model.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Ziyyer';
  static const String appVersion = '1.0.0';
  static const int databaseVersion = 1;

  // API URLs
  static const String baseUrl = 'https://api.ziyyer.com';

  // Other constants
  static const double defaultPadding = 24.0;
  static const double screenMargin = 24.0;
  static const double defaultBorderRadius = 32.0;
  static const double maxBorderRadius = 999.0;

  // Supported currencies
  static const List<CurrencyModel> supportedCurrencies = [
    CurrencyModel('EUR', r'€', 'Euro'),
    CurrencyModel('USD', r'$', 'US Dollar'),
    CurrencyModel('GBP', r'£', 'British Pound'),
    CurrencyModel('CAD', r'$', 'Canadian Dollar'),
    CurrencyModel('MAD', r'DH', 'Moroccan Dirham'),
    CurrencyModel('JPY', r'¥', 'Japanese Yen'),
    CurrencyModel('AUD', r'A$', 'Australian Dollar'),
    CurrencyModel('INR', r'₹', 'Indian Rupee'),
  ];

  static const CurrencyModel defaultCurrency = CurrencyModel('EUR', r'€', 'Euro');

  // Spacing
  static const double spacingExtraSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static double spacingExtraLarge = 32.0;
}
