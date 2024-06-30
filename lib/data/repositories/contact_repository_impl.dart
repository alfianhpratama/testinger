import 'package:injectable/injectable.dart';
import 'package:testinger/core/config/data_result.dart';
import 'package:testinger/data/datasources/contact_data_source.dart';
import 'package:testinger/data/models/contact_model.dart';
import 'package:testinger/domain/entities/contact_detail_entity.dart';
import 'package:testinger/domain/entities/contact_list_entity.dart';
import 'package:testinger/domain/repositories/contact_repository.dart';

@LazySingleton(as: ContactRepository)
class ContactRepositoryImpl implements ContactRepository {
  final ContactDataSource dataSource;

  ContactRepositoryImpl(this.dataSource);

  @override
  Future<DataResult<ContactModel>> createContact(ContactModel data) async {
    await Future.delayed(const Duration(milliseconds: 700));
    try {
      final response = await dataSource.saveNewContact(data);
      if (response) {
        return DataResult.success(data);
      } else {
        return const DataResult.failed(message: 'Failed');
      }
    } catch (e) {
      return DataResult.failed(message: e.toString());
    }
  }

  @override
  Future<DataResult<ContactModel>> editContact(ContactModel data) async {
    await Future.delayed(const Duration(milliseconds: 700));
    try {
      final response = await dataSource.editContact(data);
      if (response) {
        return DataResult.success(data);
      } else {
        return const DataResult.failed(message: 'Failed');
      }
    } catch (e) {
      return DataResult.failed(message: e.toString());
    }
  }

  @override
  Future<DataResult<ContactDetailEntity>> getDetailContact(String id) async {
    await Future.delayed(const Duration(milliseconds: 700));
    // try {
    final response = await dataSource.getDetail(id);
    if (response != null) {
      return DataResult.success(response.toContactDetailEntity());
    } else {
      return const DataResult.failed(message: 'No Data');
    }
    // } catch (e) {
    //   return DataResult.failed(message: e.toString());
    // }
  }

  @override
  Future<DataResult<List<ContactListEntity>>> getListContact(
      {bool isForce = false}) async {
    await Future.delayed(const Duration(milliseconds: 700));
    try {
      final response = await dataSource.getList(isForce: isForce);
      if (response.isNotEmpty) {
        return DataResult.success(
          response.map((e) => e.toContactListEntity()).toList(),
        );
      } else {
        return const DataResult.empty();
      }
    } catch (e) {
      return DataResult.failed(message: e.toString());
    }
  }

  @override
  Future<DataResult<List<ContactListEntity>>> searchListContact(
      String query) async {
    await Future.delayed(const Duration(milliseconds: 700));
    try {
      final response = await dataSource.getSearchList(query);
      if (response.isNotEmpty) {
        return DataResult.success(
          response.map((e) => e.toContactListEntity()).toList(),
        );
      } else {
        return const DataResult.empty();
      }
    } catch (e) {
      return DataResult.failed(message: e.toString());
    }
  }
}
