import 'package:bloc/bloc.dart';
import 'package:flutter_smilelaundry_user/presentation/home/models/product_quantity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/models/responses/product_response_model.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';
part 'checkout_bloc.freezed.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(const _Loaded([])) {
    on<_AddItem>((event, emit) {
      final currentState = state as _Loaded;
      final hasProduct1 =
          currentState.products.any((item) => item.product.id == 1);
      final hasProduct2 =
          currentState.products.any((item) => item.product.id == 2);

      if (event.product.id == 1 && hasProduct1) {
        print(
            'You cannot add more than one instance of Product ID 1 to the cart.');
      } else if (event.product.id == 2 && hasProduct2) {
        print(
            'You cannot add more than one instance of Product ID 2 to the cart.');
      } else if ((event.product.id == 1 && hasProduct2) ||
          (event.product.id == 2 && hasProduct1)) {
        print('You cannot add both Product ID 1 and Product ID 2 to the cart.');
      } else {
        // Proceed with adding the product to the cart
        if (currentState.products
            .any((element) => element.product.id == event.product.id)) {
          final index = currentState.products
              .indexWhere((element) => element.product.id == event.product.id);
          final item = currentState.products[index];
          final newItem = item.copyWith(quantity: item.quantity + 1);
          final newItems = currentState.products
              .map((e) => e == item ? newItem : e)
              .toList();
          emit(_Loaded(newItems));
        } else {
          final newItem = ProductQuantity(product: event.product, quantity: 1);
          final newItems = [...currentState.products, newItem];
          emit(_Loaded(newItems));
        }
      }
    });

    on<_RemoveItem>((event, emit) {
      final currentState = state as _Loaded;
      if (currentState.products
          .any((element) => element.product.id == event.product.id)) {
        final index = currentState.products
            .indexWhere((element) => element.product.id == event.product.id);
        final item = currentState.products[index];
        //if quantity is 1, remove the item
        if (item.quantity == 1) {
          final newItems = currentState.products
              .where((element) => element.product.id != event.product.id)
              .toList();
          emit(_Loaded(newItems));
        } else {
          final newItem = item.copyWith(quantity: item.quantity - 1);
          final newItems = currentState.products
              .map((e) => e == item ? newItem : e)
              .toList();
          emit(_Loaded(newItems));
        }
      }
    });

    //on started
    on<_Started>((event, emit) {
      emit(const _Loaded([]));
    });
  }
}
