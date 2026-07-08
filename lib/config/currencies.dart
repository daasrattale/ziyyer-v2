class Currency {
  final String code;
  final String symbol;
  final String name;

  const Currency({required this.code, required this.symbol, required this.name});
}

class Currencies {
  Currencies._();

  // Supported currencies with their display info
  static const List<Currency> supported = [
    Currency(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
    Currency(code: 'USD', symbol: '\$', name: 'US Dollar'),
    Currency(code: 'EUR', symbol: '€', name: 'Euro'),
    Currency(code: 'GBP', symbol: '£', name: 'British Pound'),
    Currency(code: 'CNY', symbol: '¥', name: 'Chinese Yuan'),
    Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
  ];

  static const String defaultCurrency = 'JPY';

  /// Quick-set amount presets in base currency units
  static const List<double> quickSetAmounts = [1500.0, 3000.0, 5000.0, 8000.0];

  /// Get currency by code
  static Currency? getByCode(String code) {
    try {
      return supported.firstWhere((c) => c.code == code);
    } catch (e) {
      return null;
    }
  }

  /// Get currency symbol by code
  static String getSymbol(String code) {
    return getByCode(code)?.symbol ?? code;
  }

  /// Get currency name by code
  static String getName(String code) {
    return getByCode(code)?.name ?? code;
  }
}
