part of 'add_contact_cubit.dart';

@freezed
class AddContactState with _$AddContactState {
  const factory AddContactState({
    required DataResult<ContactDetailEntity> dataDetail,
    required DataResult<void> dataSubmit,
  }) = _AddContactState;

  factory AddContactState.initial() => AddContactState(
        dataDetail: DataResult<ContactDetailEntity>.initial(),
        dataSubmit: DataResult<void>.initial(),
      );
}
