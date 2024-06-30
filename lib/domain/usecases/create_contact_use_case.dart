import 'package:injectable/injectable.dart';
import 'package:testinger/core/core.dart';
import 'package:testinger/data/models/contact_model.dart';
import 'package:testinger/domain/repositories/contact_repository.dart';

@lazySingleton
class CreateContactUseCase {
  final ContactRepository repository;

  CreateContactUseCase(this.repository);

  Future<DataResult<ContactModel>> call(ContactModel data) =>
      repository.createContact(data);
}