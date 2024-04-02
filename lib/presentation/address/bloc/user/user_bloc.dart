// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_smilelaundry_user/data/datasources/user_remote_datasource.dart';

import '../../../../data/models/responses/user_response_model.dart';

part 'user_bloc.freezed.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRemoteDatasource userRemoteDatasource;
  UserBloc(
    this.userRemoteDatasource,
  ) : super(_Initial()) {
    on<_GetUser>((event, emit) async {
      emit(const _Loading());
      final response = await userRemoteDatasource.getUser();
      response.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r.data!)),
      );
    });
  }
}
