import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:testinger/core/core.dart';
import 'package:testinger/domain/entities/contact_detail_entity.dart';
import 'package:testinger/domain/entities/contact_list_entity.dart';

part 'contact_model.g.dart';

@JsonSerializable()
class ContactModel {
  String id;
  String? firstName;
  String? lastName;
  String? email;
  String? dob;

  ContactModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.dob,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContactModelToJson(this);

  ContactDetailEntity toContactDetailEntity() => ContactDetailEntity(
        id: id,
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        email: email ?? '-',
        dob: dob?.toDateTime(),
      );

  ContactListEntity toContactListEntity() =>
      ContactListEntity(id: id, name: '$firstName $lastName');
}
