// ignore_for_file: use_super_parameters, library_private_types_in_public_api

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
import '../bloc/user/user_bloc.dart';

class EditAddressPage extends StatefulWidget {
  final String currentAddress;
  final double haversineDistanceText;
  final String manhattanDistanceText;
  final String euclideanDistanceText;
  final double titikLat;
  final double titikLong;

  const EditAddressPage({
    Key? key,
    required this.currentAddress,
    required this.haversineDistanceText,
    required this.manhattanDistanceText,
    required this.euclideanDistanceText,
    required this.titikLat,
    required this.titikLong,
  }) : super(key: key);

  @override
  _EditAddressPageState createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  late TextEditingController addressController;
  late TextEditingController noteAddressController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late String haversineController;
  bool _isFieldsInitialized = false;

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController(text: widget.currentAddress);
    noteAddressController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    haversineController = widget.haversineDistanceText.toStringAsFixed(2);
    context.read<UserBloc>().add(const UserEvent.getUser());
  }

  @override
  void dispose() {
    addressController.dispose();
    noteAddressController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Address'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text(
            'Note: Kami hanya bisa melayani antar-jemput pakaian bagi pelanggan yang berada dalam radius 500 meter dari Smile Laundry',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.justify,
          ),
          const SpaceHeight(24.0),
          const Text(
            'Silakan melakukan pengecekan radius dengan menekan tombol "Check"',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.justify,
          ),
          const SpaceHeight(24.0),
          const Text(
            'GPS',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SpaceHeight(10.0),
          Row(
            children: [
              const SizedBox(width: 70.0),
              Expanded(
                child: Button.filled(
                  onPressed: () {
                    context.goNamed(
                      RouteConstants.checkAddress,
                      pathParameters:
                          PathParameters(rootTab: RootTab.order).toMap(),
                    );
                  },
                  label: 'Check',
                  icon: Assets.icons.location.svg(
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 70.0),
            ],
          ),
          const SpaceHeight(24.0),
          const Text(
            'Jarak radius lokasi rumahmu dari Smile Laundry: ',
            style: TextStyle(fontSize: 14),
          ),
          Text(
            'Haversine Distance: $haversineController meters',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SpaceHeight(24.0),
          CustomTextField(
            controller: addressController,
            label: 'Alamat',
            readOnly: true,
          ),
          const Text(
            'Alamat akan otomatis terisi dan tidak dapat diedit ketika Anda sudah menekan tombol check',
            style: TextStyle(fontSize: 10),
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
          BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              return userState.maybeWhen(
                loaded: (user) {
                  if (!_isFieldsInitialized) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          addressController.text = user.address ?? '';
                          noteAddressController.text = user.noteAddress ?? '';
                          nameController.text = user.name ?? '';
                          phoneController.text = user.phone ?? '';
                          haversineController = user.radius!.toStringAsFixed(2);
                          _isFieldsInitialized =
                              true; // Setel _isFieldsInitialized menjadi true setelah diperbarui
                        });
                      }
                    });
                  }
                  return BlocConsumer<AddAddressBloc, AddAddressState>(
                    listener: (context, state) {
                      state.maybeWhen(
                        orElse: () {},
                        loaded: () {
                          context.goNamed(
                            RouteConstants.address,
                            pathParameters:
                                PathParameters(rootTab: RootTab.order).toMap(),
                          );
                        },
                      );
                    },
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () {
                          return Button.filled(
                            onPressed: () {
                              if (widget.haversineDistanceText > 500.00) {
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
                                            addressRequestModel:
                                                UserRequestModel(
                                              name: nameController.text,
                                              address: addressController.text,
                                              noteAddress:
                                                  noteAddressController.text,
                                              phone: phoneController.text,
                                              radius:
                                                  widget.haversineDistanceText !=
                                                          0
                                                      ? widget
                                                          .haversineDistanceText
                                                      : user.radius,
                                              latitudeUser: widget.titikLat != 0
                                                  ? widget.titikLat
                                                  : user.latitudeUser,
                                              longitudeUser:
                                                  widget.titikLong != 0
                                                      ? widget.titikLong
                                                      : user.longitudeUser,
                                            ),
                                          ),
                                        );
                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.loading,
                                      title: "Loading",
                                      text: "Please wait...",
                                      autoCloseDuration:
                                          const Duration(seconds: 2),
                                    );

                                    // Delay sebelum melakukan navigasi
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
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
                            label: 'Edit Alamat',
                          );
                        },
                      );
                    },
                  );
                },
                orElse: () {
                  return const Center(child: CircularProgressIndicator());
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
