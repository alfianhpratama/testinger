import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:testinger/core/core.dart';
import 'package:testinger/domain/entities/contact_list_entity.dart';
import 'package:testinger/domain/usecases/get_list_contact_use_case.dart';
import 'package:testinger/domain/usecases/search_list_contact_use_case.dart';

part 'contact_state.dart';

part 'contact_cubit.freezed.dart';

@injectable
class ContactCubit extends Cubit<ContactState> {
  final GetListContactUseCase getListContactUseCase;
  final SearchListContactUseCase searchListContactUseCase;

  ContactCubit(
    this.getListContactUseCase,
    this.searchListContactUseCase,
  ) : super(ContactState.initial());

  void getData({bool isForce = false}) async {
    emit(state.copyWith(data: const DataResult.loading()));
    final result = await getListContactUseCase(isForce: isForce);
    emit(state.copyWith(data: result));
  }

  void search(String query) async {
    emit(state.copyWith(data: const DataResult.loading()));
    final result = await searchListContactUseCase(query);
    emit(state.copyWith(data: result));
  }
}
