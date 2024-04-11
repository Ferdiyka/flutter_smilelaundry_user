// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter_smilelaundry_user/data/datasources/order_remote_datasource.dart';
import 'package:flutter_smilelaundry_user/data/models/responses/history_order_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_event.dart';
part 'history_state.dart';
part 'history_bloc.freezed.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final OrderRemoterDatasource orderRemoteDatasource;
  HistoryBloc(
    this.orderRemoteDatasource,
  ) : super(const _Initial()) {
    on<_HistoryOrder>((event, emit) async {
      emit(const _Loading());
      final response = await orderRemoteDatasource.getOrders();
      response.fold(
        (l) => emit(const _Error('Error')),
        (r) => emit(_Loaded(r)),
      );
    });
  }
}
