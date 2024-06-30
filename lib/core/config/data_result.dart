import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_result.freezed.dart';

@freezed
class DataResult<T> with _$DataResult {
  const factory DataResult.initial() = _DataResultInitial;

  const factory DataResult.loading({String? message}) = _DataResultLoading;

  const factory DataResult.success(T data) = _DataResultSuccess;

  const factory DataResult.failed({
    required String message,
    int? code,
    dynamic data,
  }) = _DataResultFailed;

  const factory DataResult.empty() = _DataResultEmpty;
}
