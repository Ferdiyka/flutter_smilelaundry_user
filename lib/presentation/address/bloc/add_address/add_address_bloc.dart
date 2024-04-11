// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter_smilelaundry_user/data/models/requests/user_request_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/user_remote_datasource.dart';

part 'add_address_event.dart';
part 'add_address_state.dart';
part 'add_address_bloc.freezed.dart';

class AddAddressBloc extends Bloc<AddAddressEvent, AddAddressState> {
  final UserRemoteDatasource userRemoteDatasource;
  AddAddressBloc(
    this.userRemoteDatasource,
  ) : super(const _Initial()) {
    on<_AddAddress>((event, emit) async {
      emit(const AddAddressState.loading());
      final response =
          await userRemoteDatasource.addAddress(event.addressRequestModel);
      response.fold(
        (failure) => emit(AddAddressState.error(failure.toString())),
        (_) => emit(const AddAddressState.loaded()),
      );
    });
  }
}
