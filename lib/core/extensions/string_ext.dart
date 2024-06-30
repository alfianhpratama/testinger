import 'package:intl/intl.dart';

extension StringExt on String {
  DateTime? toDateTime({String pattern = 'dd/MM/yyyy'}) {
    try {
      return DateFormat(pattern).tryParse(this);
    } catch (_) {
      return null;
    }
  }
}
