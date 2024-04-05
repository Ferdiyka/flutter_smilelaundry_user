import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smilelaundry_user/data/models/responses/user_response_model.dart';
import 'package:go_router/go_router.dart';

import '../../../core/components/buttons.dart';
import '../../../core/router/app_router.dart';
import '../bloc/user/user_bloc.dart';
import '../models/address_model.dart';
import '../widgets/address_tile.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(const UserEvent.getUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alamat Pengiriman',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                return state.when(
                  initial: () =>
                      const Center(child: CircularProgressIndicator()),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
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
                          // Implementasi ketika tombol edit alamat ditekan
                        },
                      );
                    } else {
                      return const Text('Alamat tidak ditemukan');
                    }
                  },
                );
              },
            ),
            const Spacer(),
            Button.outlined(
              onPressed: () {
                context.goNamed(
                  RouteConstants.addAddress,
                  pathParameters: PathParameters(
                    rootTab: RootTab.order,
                  ).toMap(),
                );
              },
              label: 'Tambah Alamat',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Informasi subtotal dan tombol lanjutkan
          ],
        ),
      ),
    );
  }
}
