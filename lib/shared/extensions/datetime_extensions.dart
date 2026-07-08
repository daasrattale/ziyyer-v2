import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String prettyDate([String locale = 'en']) {
    return DateFormat('E d MMMM y', locale).format(this);
  }
}
