import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smilelaundry_user/core/core.dart';
import 'package:go_router/go_router.dart';

import '../../../core/components/buttons.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/responses/product_response_model.dart';

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
    final productId = widget.productId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Detail - $productId'),
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
          IconButton(
            onPressed: () {},
            icon: Assets.icons.notification.svg(height: 24.0),
          ),
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
              data.price!.currencyFormatRp,
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
            const Spacer(),
            SizedBox(
              height: 80.0, // Ubah nilai sesuai kebutuhan
              child: Row(
                children: [
                  Expanded(
                    child: Button.outlined(
                      onPressed: () {
                        context
                            .read<CheckoutBloc>()
                            .add(CheckoutEvent.addItem(data));
                      },
                      label: 'Add to cart',
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Button.filled(
                      onPressed: () {
                        // Checkout functionality
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
