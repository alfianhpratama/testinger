import 'dart:developer';

import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  String format({String pattern = 'yyyy-MM-dd HH:mm:ss'}) {
    try {
      return DateFormat(pattern).format(this);
    } catch (e) {
      log('Error formater date time to string $e');
      return toString();
    }
  }

  String get toddMMyyyy => format(pattern: 'dd/MM/yyyy');

  String get toddMMMMyyyy => format(pattern: 'dd MMMM yyyy');
}
