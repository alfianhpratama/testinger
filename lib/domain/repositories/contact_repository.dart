import 'package:testinger/core/core.dart';
import 'package:testinger/data/models/contact_model.dart';
import 'package:testinger/domain/entities/contact_detail_entity.dart';
import 'package:testinger/domain/entities/contact_list_entity.dart';

abstract interface class ContactRepository {
  Future<DataResult<ContactModel>> createContact(ContactModel data);

  Future<DataResult<ContactModel>> editContact(ContactModel data);

  Future<DataResult<ContactDetailEntity>> getDetailContact(String id);

  Future<DataResult<List<ContactListEntity>>> getListContact(
      {bool isForce = false});

  Future<DataResult<List<ContactListEntity>>> searchListContact(String query);
}
