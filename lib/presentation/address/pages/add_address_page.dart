import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';
import '../../../core/router/app_router.dart';

class AddAddressPage extends StatelessWidget {
  final String currentAddress;
  final String haversineDistanceText;
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
                  ),
                ),
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
            '$haversineDistanceText',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$manhattanDistanceText',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$euclideanDistanceText',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$titikLat',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          Text(
            '$titikLong',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          const SpaceHeight(24.0),
          CustomTextField(
            controller: addressController,
            label: 'Alamat',
            readOnly: true,
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
          Button.filled(
            onPressed: () {
              context.pop();
            },
            label: 'Tambah Alamat',
          ),
        ],
      ),
    );
  }
}
