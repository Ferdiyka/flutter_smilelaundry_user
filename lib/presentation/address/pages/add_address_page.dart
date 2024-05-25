import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/assets/assets.gen.dart';
import '../../../data/models/requests/user_request_model.dart';
import '../bloc/add_address/add_address_bloc.dart';

class AddAddressPage extends StatelessWidget {
  final String currentAddress;
  final double haversineDistanceText;
  final String manhattanDistanceText;
  final String euclideanDistanceText;
  final double titikLat;
  final double titikLong;
  const AddAddressPage(
      {super.key,
      required this.currentAddress,
      required this.haversineDistanceText,
      required this.manhattanDistanceText,
      required this.euclideanDistanceText,
      required this.titikLat,
      required this.titikLong});

  @override
  Widget build(BuildContext context) {
    final addressController = TextEditingController(text: currentAddress);
    addressController.selection = TextSelection.fromPosition(
      TextPosition(offset: addressController.text.length),
    );
    final noteAddressController = TextEditingController();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Adress'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text(
            'Note: Kami hanya bisa melayani antar-jemput pakaian bagi pelanggan yang berada dalam radius 500 meter dari Smile Laundry',
            style: TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.justify,
          ),
          const SpaceHeight(24.0),
          const Text(
            'Silakan melakukan pengecekan radius dengan menekan tombol "Check"',
            style: TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.justify,
          ),
          const SpaceHeight(24.0),
          const Text(
            'GPS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SpaceHeight(10.0),
          SizedBox(
            child: Row(
              children: [
                const SizedBox(width: 70.0),
                Expanded(
                    child: Button.filled(
                  onPressed: () {
                    context.goNamed(
                      RouteConstants.checkAddress,
                      pathParameters: PathParameters(
                        rootTab: RootTab.order,
                      ).toMap(),
                    );
                  },
                  label: 'Check',
                  icon: Assets.icons.location.svg(
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                )),
                const SizedBox(width: 70.0),
              ],
            ),
          ),
          const SpaceHeight(24.0),
          const Text(
            'Jarak radius lokasi rumahmu dari Smile Laundry: ',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          Text(
            'Haversine Distance: '
            '${haversineDistanceText.toStringAsFixed(2)}'
            ' meters',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            manhattanDistanceText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            euclideanDistanceText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$titikLat',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          Text(
            '$titikLong',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SpaceHeight(24.0),
          CustomTextField(
            controller: addressController,
            label: 'Alamat',
            readOnly: true,
          ),
          const Text(
            'Alamat akan otomatis terisi dan tidak dapat diedit ketika Anda sudah menekan tombol check',
            style: TextStyle(
              fontSize: 10,
            ),
            textAlign: TextAlign.justify,
          ),
          const SpaceHeight(24.0),
          CustomTextField(
            controller: noteAddressController,
            label: 'Catatan Alamat (blok/nomor)',
          ),
          const SpaceHeight(24.0),
          CustomTextField(
            controller: nameController,
            label: 'Nama Lengkap',
          ),
          const SpaceHeight(24.0),
          CustomTextField(
            controller: phoneController,
            label: 'Nomor Telepon',
          ),
          const SpaceHeight(24.0),
          BlocConsumer<AddAddressBloc, AddAddressState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                loaded: () {
                  context.goNamed(
                    RouteConstants.address,
                    pathParameters: PathParameters(
                      rootTab: RootTab.order,
                    ).toMap(),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return Button.filled(
                    onPressed: () {
                      if (addressController.text.isEmpty ||
                          noteAddressController.text.isEmpty ||
                          nameController.text.isEmpty ||
                          phoneController.text.isEmpty) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Terjadi Kesalahan",
                          text: 'Harap isi semua input yang diperlukan',
                          confirmBtnText: 'OK',
                          textColor: AppColors.mainTextColor,
                          confirmBtnColor: AppColors.secondaryColor,
                        );
                      } else if (haversineDistanceText > 500.00) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Terjadi Kesalahan",
                          text:
                              'Maaf, radius tidak boleh melebihi 500 meter. Untuk itu Anda tidak bisa memesan di aplikasi ini, Untuk informasi lebih lanjut silakan hubungi kontak yang tertera di halaman about atau datang langsung ke alamat kami',
                          confirmBtnText: 'OK',
                          textColor: AppColors.mainTextColor,
                          confirmBtnColor: AppColors.secondaryColor,
                        );
                      } else {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text: 'Apa Anda yakin alamat sudah benar?',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          textColor: AppColors.mainTextColor,
                          confirmBtnColor: AppColors.secondaryColor,
                          onConfirmBtnTap: () {
                            context.read<AddAddressBloc>().add(
                                  AddAddressEvent.addAddress(
                                    addressRequestModel: UserRequestModel(
                                      name: nameController.text,
                                      address: addressController.text,
                                      noteAddress: noteAddressController.text,
                                      phone: phoneController.text,
                                      radius: haversineDistanceText,
                                      latitudeUser: titikLat,
                                      longitudeUser: titikLong,
                                    ),
                                  ),
                                );
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );

                            // Delay sebelum melakukan navigasi
                            Future.delayed(const Duration(seconds: 2), () {
                              // Hapus dialog loading
                              Navigator.of(context).pop();

                              // Navigasi kembali ke OrderDetailPage
                              context.goNamed(
                                RouteConstants.orderDetail,
                                pathParameters: PathParameters(
                                  rootTab: RootTab.order,
                                ).toMap(),
                              );
                            });
                          },
                        );
                      }
                    },
                    label: 'Tambah Alamat',
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
        ],
      ),
    );
  }
}
