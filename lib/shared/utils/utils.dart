import 'dart:convert';

class Utils {
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  static Map<String, dynamic> decodeJson(String jsonString) {
    return json.decode(jsonString);
  }

  static String encodeJson(Map<String, dynamic> data) {
    return json.encode(data);
  }

  // Add more utility functions
}
