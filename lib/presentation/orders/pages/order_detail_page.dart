import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smilelaundry_user/core/extensions/int_ext.dart';
import 'package:flutter_smilelaundry_user/presentation/address/pages/address_page.dart';
import 'package:go_router/go_router.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/responses/user_response_model.dart';
import '../../address/bloc/user/user_bloc.dart';
import '../../address/widgets/address_tile.dart';
import '../../home/bloc/checkout/checkout_bloc.dart';
import '../../home/models/product_quantity.dart';
import '../bloc/order_bloc.dart';
import '../widgets/cart_tile.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(const UserEvent.getUser());
  }

  void onCheckout() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                child: ColoredBox(
                  color: AppColors.light,
                  child: SizedBox(height: 8.0, width: 55.0),
                ),
              ),
              const SpaceHeight(20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Center(
                    child: Text(
                      'Pemesanan Berhasil!',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.light,
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SpaceHeight(20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Assets.images.processOrder.image(),
              ),
              const SpaceHeight(50.0),
              Row(
                children: [
                  Flexible(
                    child: Button.filled(
                      onPressed: () {
                        context.goNamed(
                          RouteConstants.root,
                          pathParameters: PathParameters().toMap(),
                        );
                      },
                      label: 'Back to Home',
                    ),
                  ),
                  const SpaceWidth(20.0),
                  Flexible(
                    child: Button.outlined(
                      onPressed: () {
                        context.pushNamed(
                          RouteConstants.trackingOrder,
                          pathParameters: PathParameters().toMap(),
                        );
                      },
                      label: 'Lacak Pesanan',
                    ),
                  ),
                ],
              ),
              const SpaceHeight(20.0),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          BlocBuilder<CheckoutBloc, CheckoutState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return const SizedBox();
                },
                loaded: (products) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) => CartTile(
                      data: products[index],
                    ),
                    separatorBuilder: (context, index) =>
                        const SpaceHeight(16.0),
                  );
                },
              );
            },
          ),
          const SpaceHeight(36.0),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return state.when(
                initial: () => const Center(child: CircularProgressIndicator()),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (message) => Text('Error: $message'),
                loaded: (user) {
                  if (user.address != null) {
                    return AddressTile(
                      data: User(
                        name: user.name!,
                        address: user
                            .address!, // Gunakan operator null-aware (!) untuk menegaskan bahwa nilai tidak null
                        noteAddress: user.noteAddress ??
                            '', // Gunakan operator null coalescing (??) untuk memberikan nilai default jika nilai null
                        // radius: user.radius,
                        latitudeUser: user.latitudeUser,
                        longitudeUser: user.longitudeUser,
                        phone: user.phone ?? '',
                      ),
                      onTap: () {
                        // Implementasi ketika alamat dipilih
                      },
                      onEditTap: () {
                        context.pushNamed(
                          RouteConstants.addAddress,
                          pathParameters: PathParameters(
                            rootTab: RootTab.order,
                          ).toMap(),
                        );
                      },
                    );
                  } else {
                    return const Text('Alamat tidak ditemukan');
                  }
                },
              );
            },
          ),
          const SpaceHeight(36.0),
          const Divider(),
          const SpaceHeight(8.0),
          const Text(
            'Detail Belanja :',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SpaceHeight(12.0),
          BlocBuilder<CheckoutBloc, CheckoutState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => const SizedBox.shrink(),
                loaded: (products) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...products.map((product) {
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${product.product.name!} x ${product.quantity}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              product.product.price!.currencyFormatRp,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        );
                      }),
                    ],
                  );
                },
              );
            },
          ),
          const SpaceHeight(8.0),
          const Divider(),
          const SpaceHeight(24.0),
          Row(
            children: [
              const Text(
                'Total Belanja',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              BlocBuilder<CheckoutBloc, CheckoutState>(
                builder: (context, state) {
                  final total = state.maybeWhen(
                    orElse: () => 0,
                    loaded: (products) {
                      return products.fold<int>(
                        0,
                        (previousValue, element) =>
                            previousValue +
                            (element.product.price! * element.quantity),
                      );
                    },
                  );
                  return Text(
                    total.currencyFormatRp,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  );
                },
              ),
            ],
          ),
          const SpaceHeight(20.0),
          BlocBuilder<CheckoutBloc, CheckoutState>(
            builder: (context, state) {
              final products = state.maybeWhen(
                orElse: () => [],
                loaded: (products) => products,
              );

              return BlocListener<OrderBloc, OrderState>(
                listener: (context, state) {
                  state.maybeWhen(
                    orElse: () {},
                    loaded: (orderResponseModel) {},
                    error: (message) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.red,
                          content: Text(message),
                        ),
                      );
                    },
                  );
                },
                child: BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () {
                        return Button.filled(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: const Text("Konfirmasi Checkout"),
                                  content: const Text(
                                      "Anda yakin semua pesanan sudah benar?"),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Tutup dialog
                                      },
                                      child: const Text("Batal"),
                                    ),
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        context
                                            .read<CheckoutBloc>()
                                            .add(const CheckoutEvent.started());
                                        context.read<OrderBloc>().add(
                                            OrderEvent.doOrder(
                                                products: products
                                                    as List<ProductQuantity>));
                                        onCheckout();
                                      },
                                      child: const Text("Ya"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          label: 'Checkout',
                        );
                      },
                      loading: () {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
