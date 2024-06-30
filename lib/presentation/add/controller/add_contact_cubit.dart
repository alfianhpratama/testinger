import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:testinger/core/core.dart';
import 'package:testinger/data/models/contact_model.dart';
import 'package:testinger/domain/entities/contact_detail_entity.dart';
import 'package:testinger/domain/usecases/create_contact_use_case.dart';
import 'package:testinger/domain/usecases/edit_contact_use_case.dart';
import 'package:testinger/domain/usecases/get_detail_contact_use_case.dart';

part 'add_contact_state.dart';

part 'add_contact_cubit.freezed.dart';

@injectable
class AddContactCubit extends Cubit<AddContactState> {
  final GetDetailContactUseCase getDetailContactUseCase;
  final CreateContactUseCase createContactUseCase;
  final EditContactUseCase editContactUseCase;

  AddContactCubit(
    this.getDetailContactUseCase,
    this.createContactUseCase,
    this.editContactUseCase,
  ) : super(AddContactState.initial());

  void getDetail(String id) async {
    emit(state.copyWith(dataDetail: const DataResult.loading()));
    final result = await getDetailContactUseCase(id);
    emit(state.copyWith(dataDetail: result));
  }

  void editData(ContactModel data) async {
    emit(state.copyWith(dataSubmit: const DataResult.loading()));
    final result = await editContactUseCase(data);
    emit(state.copyWith(dataSubmit: result));
  }

  void createData(ContactModel data) async {
    emit(state.copyWith(dataSubmit: const DataResult.loading()));
    final result = await createContactUseCase(data);
    emit(state.copyWith(dataSubmit: result));
  }
}
