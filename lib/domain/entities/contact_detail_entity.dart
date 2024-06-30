import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_detail_entity.freezed.dart';

@freezed
class ContactDetailEntity with _$ContactDetailEntity {
  const factory ContactDetailEntity({
    required String id,
    required String firstName,
    required String lastName,
    required String email,
    DateTime? dob,
  }) = _ContactDetailEntity;
}
