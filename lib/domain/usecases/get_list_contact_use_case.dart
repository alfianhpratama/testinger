import 'package:injectable/injectable.dart';
import 'package:testinger/core/core.dart';
import 'package:testinger/domain/entities/contact_list_entity.dart';
import 'package:testinger/domain/repositories/contact_repository.dart';

@lazySingleton
class GetListContactUseCase {
  final ContactRepository repository;

  GetListContactUseCase(this.repository);

  Future<DataResult<List<ContactListEntity>>> call({bool isForce = false}) =>
      repository.getListContact(isForce: isForce);
}
