import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testinger/core/core.dart';
import 'package:testinger/data/models/contact_model.dart';

abstract interface class ContactDataSource {
  Future<List<ContactModel>> getList({bool isForce = false});

  Future<List<ContactModel>> getSearchList(String query);

  Future<ContactModel?> getDetail(String id);

  Future<bool> editContact(ContactModel data);

  Future<bool> saveNewContact(ContactModel data);
}

@LazySingleton(as: ContactDataSource)
class ContactDataSourceImpl implements ContactDataSource {
  final SharedPreferences sessions;

  ContactDataSourceImpl(this.sessions);

  @override
  Future<bool> editContact(ContactModel data) async {
    try {
      final dataList = await getList();
      if (dataList.isNotEmpty) {
        final result = List<ContactModel>.empty(growable: true);
        result.addAll(dataList);
        final current =
            result.where((cData) => cData.id == data.id).firstOrNull;
        if (current != null) {
          final idx = result.indexWhere((cData) => cData.id == data.id);
          result[idx] = data;
          final list = result.map((e) => jsonEncode(e.toJson())).toList();
          await sessions.setStringList(Constants.sessionKey, list);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> saveNewContact(ContactModel data) async {
    try {
      final dataList = await getList();
      final result = List<ContactModel>.empty(growable: true);
      result.addAll(dataList);
      result.insert(0, data);
      final list = result.map((e) => jsonEncode(e.toJson())).toList();
      await sessions.setStringList(Constants.sessionKey, list);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ContactModel?> getDetail(String id) async {
    try {
      final dataList = await getList();
      final list = List<ContactModel>.empty(growable: true);
      list.addAll(dataList);
      final result = list.where((cData) => cData.id == id).firstOrNull;
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ContactModel>> getList({bool isForce = false}) async {
    try {
      if (!isForce && sessions.containsKey(Constants.sessionKey)) {
        final response = sessions.getStringList(Constants.sessionKey);
        final dataList = response!.map(((e) => jsonDecode(e))).toList();
        return (dataList as List<dynamic>?)
                ?.map((e) =>
                    ContactModel.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList() ??
            const [];
      } else {
        final String response = await rootBundle.loadString('assets/data.json');
        final dataList = json.decode(response);
        final result = (dataList as List<dynamic>?)
                ?.map((e) =>
                    ContactModel.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList() ??
            const [];
        final list = result.map((e) => jsonEncode(e.toJson())).toList();
        await sessions.setStringList(Constants.sessionKey, list);
        return result;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ContactModel>> getSearchList(String query) async {
    try {
      final dataList = await getList();
      return dataList.where((data) {
        return (data.firstName ?? '')
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            (data.lastName ?? '').toLowerCase().contains(query.toLowerCase()) ||
            (data.email ?? '').toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      rethrow;
    }
  }
}
