import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smilelaundry_user/core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';

import '../../../core/components/buttons.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/responses/product_response_model.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

import 'package:badges/badges.dart' as badges;

import '../bloc/checkout/checkout_bloc.dart';

class ProductDetailPage extends StatefulWidget {
  final Product data;
  final String productId;
  const ProductDetailPage(
      {super.key, required this.productId, required this.data});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate to home page
            context.goNamed(
              RouteConstants.root,
              pathParameters: PathParameters().toMap(),
            );
          },
        ),
        actions: [
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
          const SizedBox(width: 16.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Image.network(
                  data.pictureUrl!,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            Text(
              data.name!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '${data.price!.currencyFormatRp}${data.name!.toLowerCase().contains('paket') ? "/Kg" : "/Pcs"}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.thirdColor,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              '${data.duration.toString()} Hari',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),
            const Text(
              'Description Product',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.description!,
                      style: const TextStyle(fontSize: 14.0),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Note',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      data.note!,
                      style: const TextStyle(fontSize: 14.0),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 80.0, // Ubah nilai sesuai kebutuhan
              child: Row(
                children: [
                  if (data.name!
                      .toLowerCase()
                      .contains('paket')) // Jika produk adalah "Paket"
                    Expanded(
                      child: Button.filled(
                        onPressed: () {
                          final isPaketExpressExist = context
                              .read<CheckoutBloc>()
                              .isPaketExpressExist();
                          final isPaketRegulerExist = context
                              .read<CheckoutBloc>()
                              .isPaketRegulerExist();
                          //Jika product yang ditambah adalah mengandung kata paket express dan di cart sudah isPaketExpressExist
                          if (data.name!
                                  .toLowerCase()
                                  .contains('paket express') &&
                              isPaketExpressExist) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.info,
                              title: "Terjadi Kesalahan",
                              text:
                                  'Anda cukup menambahkan Paket Express sekali saja',
                            );
                            //Jika product yang ditambah adalah mengandung kata paket reguler dan di cart sudah isPaketRegulerExist
                          } else if (data.name!
                                  .toLowerCase()
                                  .contains('paket reguler') &&
                              isPaketRegulerExist) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.info,
                              title: "Terjadi Kesalahan",
                              text:
                                  'Anda cukup menambahkan Paket Reguler sekali saja',
                            );
                          } else {
                            context
                                .read<CheckoutBloc>()
                                .add(CheckoutEvent.addItem(data));
                            context.goNamed(
                              RouteConstants.cart,
                              pathParameters: PathParameters().toMap(),
                            );
                          }
                        },
                        label: 'Checkout Now',
                      ),
                    )
                  else // Jika produk bukan "Paket"
                    Expanded(
                      child: Button.outlined(
                        onPressed: () {
                          context
                              .read<CheckoutBloc>()
                              .add(CheckoutEvent.addItem(data));
                          AnimatedSnackBar.material(
                            'Product berhasil ditambah',
                            type: AnimatedSnackBarType.success,
                            duration: const Duration(seconds: 1),
                          ).show(context);
                        },
                        label: 'Add to Cart',
                      ),
                    ),
                  const SizedBox(width: 16.0),
                  if (!data.name!
                      .toLowerCase()
                      .contains('paket')) // Jika produk bukan "Paket"
                    Expanded(
                      child: Button.filled(
                        onPressed: () {
                          context
                              .read<CheckoutBloc>()
                              .add(CheckoutEvent.addItem(data));
                          context.goNamed(
                            RouteConstants.cart,
                            pathParameters: PathParameters().toMap(),
                          );
                        },
                        label: 'Checkout Now',
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
