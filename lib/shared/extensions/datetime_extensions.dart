import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  String prettyDate([String locale = 'en']) {
    return DateFormat('E d MMMM y', locale).format(this);
  }

  String monthAndYear([String locale = 'en']) {
    return DateFormat('MMMM y', locale).format(this);
  }

  String fullDateTime([String locale = 'en']) {
    return DateFormat('E d MMMM y HH:ss a', locale).format(this);
  }
}
