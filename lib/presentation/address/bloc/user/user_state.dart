part of 'user_bloc.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.error(String message) = _Error;
  const factory UserState.loaded(User user) = _Loaded;
}
