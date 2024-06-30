import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:testinger/core/extensions/date_time_ext.dart';

class ConverterForceDateTime implements JsonConverter<DateTime?, dynamic> {
  const ConverterForceDateTime();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null || json.toString().isEmpty) return null;
    return DateFormat('dd/MM/yyy').tryParse(json.toString());
  }

  @override
  String? toJson(DateTime? object) => object?.format();
}
