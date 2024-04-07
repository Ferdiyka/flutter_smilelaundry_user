import 'package:bloc/bloc.dart';
import 'package:flutter_smilelaundry_user/data/datasources/order_remote_datasource.dart';
import 'package:flutter_smilelaundry_user/data/models/requests/order_request_model.dart';
import 'package:flutter_smilelaundry_user/data/models/responses/order_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../home/models/product_quantity.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRemoterDatasource orderRemoteDatasource;
  OrderBloc(
    this.orderRemoteDatasource,
  ) : super(const _Initial()) {
    on<_DoOrder>((event, emit) async {
      emit(const _Loading());
      final orderRequestData = OrderRequestModel(
          items: event.products
              .map((e) => Item(productId: e.product.id!, quantity: e.quantity))
              .toList());
      final response = await orderRemoteDatasource.order(orderRequestData);
      response.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r)),
      );
    });
  }
}
