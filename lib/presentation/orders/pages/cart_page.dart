// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smilelaundry_user/data/datasources/user_remote_datasource.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/core.dart';
import '../../../core/router/app_router.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../home/bloc/checkout/checkout_bloc.dart';
import '../widgets/cart_tile.dart';
import 'package:badges/badges.dart' as badges;

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isPaketExistAtCart =
        context.read<CheckoutBloc>().isPaketExistAtCart();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            onPressed: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.info,
                text:
                    'Jika Anda memesan Kategori Paket maka berat pada Paket perlu ditimbang terlebih dahulu oleh Smile Laundry, untuk saat ini akan ditampilkan terlebih dahulu dengan tanda "?" ',
              );
            },
            icon: const Icon(Icons
                .info_outline), // Menggunakan widget Icon untuk menampilkan ikon
          ),
          BlocBuilder<CheckoutBloc, CheckoutState>(
            builder: (context, state) {
              return state.maybeWhen(
                loaded: (checkout) {
                  final totalQuantity = checkout.fold<int>(
                    0,
                    (previousValue, element) =>
                        previousValue + element.quantity,
                  );
                  return totalQuantity > 0
                      ? badges.Badge(
                          badgeContent: Text(
                            totalQuantity.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          child: IconButton(
                            onPressed: () {
                              context.goNamed(
                                RouteConstants.cart,
                                pathParameters: PathParameters().toMap(),
                              );
                            },
                            icon: Assets.icons.cart.svg(height: 24.0),
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            context.goNamed(
                              RouteConstants.cart,
                              pathParameters: PathParameters().toMap(),
                            );
                          },
                          icon: Assets.icons.cart.svg(height: 24.0),
                        );
                },
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
          const SizedBox(
            width: 16.0,
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          BlocBuilder<CheckoutBloc, CheckoutState>(
            builder: (context, state) {
              return state.maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  loaded: (checkout) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: checkout.length,
                      itemBuilder: (context, index) => CartTile(
                        data: checkout[index],
                      ),
                      separatorBuilder: (context, index) =>
                          const SpaceHeight(16.0),
                    );
                  });
            },
          ),
          const SpaceHeight(50.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isPaketExistAtCart)
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Note: Harga dan Berat Paket akan kami hitung dan tampilkan setelah ditimbang',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SpaceHeight(40.0),
                  ],
                ),
              Row(
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<CheckoutBloc, CheckoutState>(
                    builder: (context, state) {
                      final total = state.maybeWhen(
                        orElse: () => 0,
                        loaded: (checkout) {
                          // Cek apakah ada produk dengan nama yang mengandung kata 'Paket'
                          final isPaketExist =
                              context.read<CheckoutBloc>().isPaketExistAtCart();
                          return isPaketExist
                              ? 'Coming Soon'
                              : // Jika ada, kembalikan 'Coming Soon'
                              checkout.fold<int>(
                                  0,
                                  (previousValue, element) {
                                    // Jika produk tidak mengandung kata 'Paket', tambahkan biaya ke total
                                    if (!element.product.name!
                                        .toLowerCase()
                                        .contains('paket')) {
                                      return previousValue +
                                          (element.quantity *
                                              element.product.price!);
                                    }
                                    return previousValue;
                                  },
                                );
                        },
                      );
                      return Text(
                        total is int
                            ? total.currencyFormatRp
                            : total.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SpaceHeight(40.0),
          BlocBuilder<CheckoutBloc, CheckoutState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => const SizedBox.shrink(),
                loaded: (checkout) {
                  final totalQty = checkout.fold<int>(
                    0,
                    (previousValue, element) =>
                        previousValue + element.quantity,
                  );
                  return totalQty > 0
                      ? Button.filled(
                          onPressed: () async {
                            final isAuth = await AuthLocalDatasource().isAuth();
                            final hasAddress =
                                await UserRemoteDatasource().hasAddress();
                            if (!isAuth) {
                              context.pushNamed(
                                RouteConstants.login,
                              );
                            } else if (!hasAddress) {
                              // Jika pengguna tidak memiliki alamat
                              context.goNamed(
                                RouteConstants.addAddress,
                                pathParameters: PathParameters(
                                  rootTab: RootTab.order,
                                ).toMap(),
                              );
                            } else {
                              // Jika pengguna sudah memiliki alamat
                              context.goNamed(
                                RouteConstants.orderDetail,
                                pathParameters: PathParameters(
                                  rootTab: RootTab.order,
                                ).toMap(),
                              );
                            }
                          },
                          label: 'Checkout ($totalQty)',
                        )
                      : const Center(
                          child: Text(
                            'Tambahkan pesananmu ke dalam keranjang',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
