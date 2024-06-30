part of 'contact_cubit.dart';

@freezed
class ContactState with _$ContactState {
  const factory ContactState(
    DataResult<List<ContactListEntity>> data,
  ) = _ContactState;

  factory ContactState.initial() => ContactState(
        const DataResult<List<ContactListEntity>>.initial(),
      );
}
