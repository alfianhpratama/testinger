import 'package:injectable/injectable.dart';
import 'package:testinger/core/core.dart';
import 'package:testinger/domain/entities/contact_detail_entity.dart';
import 'package:testinger/domain/repositories/contact_repository.dart';

@lazySingleton
class GetDetailContactUseCase {
  final ContactRepository repository;

  GetDetailContactUseCase(this.repository);

  Future<DataResult<ContactDetailEntity>> call(String id) =>
      repository.getDetailContact(id);
}
