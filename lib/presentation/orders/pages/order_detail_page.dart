import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smilelaundry_user/core/extensions/int_ext.dart';
import 'package:flutter_smilelaundry_user/presentation/address/pages/address_page.dart';
import 'package:go_router/go_router.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/responses/user_response_model.dart';
import '../../address/bloc/user/user_bloc.dart';
import '../../address/widgets/address_tile.dart';
import '../../home/bloc/checkout/checkout_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Orders'),
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
          Button.filled(
            onPressed: () {
              context.goNamed(
                RouteConstants.paymentDetail,
                pathParameters: PathParameters().toMap(),
              );
            },
            label: 'Pilih Pembayaran',
          ),
        ],
      ),
    );
  }
}
