import 'package:ziyyer/config/app_constants.dart';
import 'package:ziyyer/shared/models/currency_model.dart';

class AmountFormatter {
  static String formatAmount(double amount, {int decimalDigits = 0}) {
    final sign = amount < 0 ? '-' : '';
    final absolute = amount.abs();
    final fixed = absolute.toStringAsFixed(decimalDigits);
    final parts = fixed.split('.');
    final integerPart = parts[0];
    final fractionPart = parts.length > 1 ? parts[1] : '';
    final groupedInteger = integerPart.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');

    return sign + groupedInteger + (fractionPart.isNotEmpty ? '.$fractionPart' : '');
  }

  static String formatCurrency(
    double amount, {
    CurrencyModel currency = AppConstants.defaultCurrency,
    int decimalDigits = 0,
    bool showCurrencyCode = false,
  }) {
    final formattedAmount = formatAmount(amount, decimalDigits: decimalDigits);
    final symbol = currency.symbol;

    if (symbol.isEmpty) {
      return showCurrencyCode ? '${currency.code} $formattedAmount' : formattedAmount;
    }

    return showCurrencyCode ? '$symbol$formattedAmount ${currency.code}' : '$symbol$formattedAmount';
  }
}
