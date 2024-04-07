part of 'order_bloc.dart';

@freezed
class OrderEvent with _$OrderEvent {
  const factory OrderEvent.started() = _Started;
  //doOrder
  const factory OrderEvent.doOrder({
    required List<ProductQuantity> products,
  }) = _DoOrder;
}
