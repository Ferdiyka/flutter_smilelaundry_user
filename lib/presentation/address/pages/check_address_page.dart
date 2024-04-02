import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class CheckAddressPage extends StatefulWidget {
  const CheckAddressPage({super.key});

  @override
  State<CheckAddressPage> createState() => _CheckAddressPageState();
}

class _CheckAddressPageState extends State<CheckAddressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: OpenStreetMapSearchAndPick(
      buttonTextStyle:
          const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
      buttonColor: Colors.blue,
      buttonText: 'Set Current Location',
      onPicked: (pickedData) {
        print(pickedData.latLong.latitude);
        print(pickedData.latLong.longitude);
        print(pickedData.address);
        print(pickedData.addressName);
      },
    ));
  }
}
