import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_list_entity.freezed.dart';

@freezed
class ContactListEntity with _$ContactListEntity {
  const factory ContactListEntity({
    required String id,
    required String name,
  }) = _ContactListEntity;
}
