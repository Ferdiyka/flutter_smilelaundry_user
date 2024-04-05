import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math';

import '../../../core/router/app_router.dart';

class CheckAddressPage extends StatefulWidget {
  const CheckAddressPage({super.key});

  @override
  State<CheckAddressPage> createState() => _CheckAddressPageState();
}

class _CheckAddressPageState extends State<CheckAddressPage> {
  String currentAddress = 'My Address';
  final double targetLat = -6.23428056838952; // Latitude titik SmileLaundry ,
  final double targetLon = 106.72582289599362; // Longitude titik SmileLaundry

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OpenStreetMapSearchAndPick(
        buttonTextStyle:
            const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
        buttonColor: Colors.blue,
        buttonText: 'Set Current Location',
        onPicked: (pickedData) async {
          // Convert the picked latitude and longitude to an address
          await _getAddressFromLatLng(
              pickedData.latLong.latitude, pickedData.latLong.longitude);

          // Calculate the Haversine distance from the picked location to the target location
          double haversineDistance = calculateHaversineDistance(
            pickedData.latLong.latitude,
            pickedData.latLong.longitude,
            targetLat,
            targetLon,
          );

          // Menghitung jarak antara posisi pengguna dan titik target menggunakan Manhattan
          double manhattanDistance = calculateManhattanDistance(
            pickedData.latLong.latitude,
            pickedData.latLong.longitude,
            targetLat,
            targetLon,
          );

          // Menghitung jarak antara posisi pengguna dan titik target menggunakan Euclidean
          double euclideanDistance = calculateEuclideanDistance(
            pickedData.latLong.latitude,
            pickedData.latLong.longitude,
            targetLat,
            targetLon,
          );

          final double haversineDistanceText = haversineDistance;
          String manhattanDistanceText =
              'Manhattan Distance: ${manhattanDistance.toStringAsFixed(2)} meters';
          String euclideanDistanceText =
              'Euclidean Distance: ${euclideanDistance.toStringAsFixed(2)} meters';
          final double titikLat = pickedData.latLong.latitude;
          final double titikLong = pickedData.latLong.longitude;

          navigateToAddAddressPage(
              context,
              currentAddress,
              haversineDistanceText,
              manhattanDistanceText,
              euclideanDistanceText,
              titikLat,
              titikLong);
        },
      ),
    );
  }

  Future<void> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];

      setState(() {
        currentAddress =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea} ${place.country}, ${place.postalCode}";
      });
    } catch (e) {
      print(e);
    }
  }

  // Rumus Matematika Haversine
  // haversine_distance = 2 * r * arcsin(sqrt(sin^2((lat2 - lat1)/2) + cos(lat1) * cos(lat2) * sin^2((lon2 - lon1)/2)))
  // Fungsi untuk menghitung jarak menggunakan algoritma Haversine
  double calculateHaversineDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // Radius of the Earth in meters

    // Convert latitude and longitude from degrees to radians
    double lat1Rad = degreesToRadians(lat1);
    double lon1Rad = degreesToRadians(lon1);
    double lat2Rad = degreesToRadians(lat2);
    double lon2Rad = degreesToRadians(lon2);

    double haversineDistance = 2 *
        earthRadius *
        asin(sqrt(sin((lat2Rad - lat1Rad) / 2) * sin((lat2Rad - lat1Rad) / 2) +
            cos(lat1Rad) *
                cos(lat2Rad) *
                sin((lon2Rad - lon1Rad) / 2) *
                sin((lon2Rad - lon1Rad) / 2)));

    return haversineDistance;
  }

  // Rumus Matematika Manhattan
  // manhattan_distance = 𝑑(x, y) = ∑ |x − y| atau |x2 - x1| + |y2 - y1| atau
  // manhattan_distance = |lat2 - lat1| + |lon2 - lon1|
  // Fungsi untuk menghitung jarak menggunakan algoritma Manhattan
  double calculateManhattanDistance(
      double lat1, double lon1, double lat2, double lon2) {
    final double latDiff = (lat2 - lat1).abs();
    final double lonDiff = (lon2 - lon1).abs();

    final double manhattanDistance = latDiff + lonDiff;

    return manhattanDistance * 111000; // (1 degree ≈ 111000 meters)
  }

  // Rumus Matematika Euclidian
  // euclidian_distance = d(x, y) = √∑(x − y)^2 atau √[(x2 - x1)^2 + (y2 - y1)^2] atau
  // euclidean_distance = √[(lat2 - lat1)^2 + (lon2 - lon1)^2]
  // Fungsi untuk menghitung jarak menggunakan algoritma Euclidean
  double calculateEuclideanDistance(
      double lat1, double lon1, double lat2, double lon2) {
    final double latDiff = lat2 - lat1;
    final double lonDiff = lon2 - lon1;

    final double euclideanDistance =
        sqrt(latDiff * latDiff + lonDiff * lonDiff);

    return euclideanDistance * 111000; // (1 degree ≈ 111000 meters)
  }

  // Fungsi untuk mengkonversi derajat menjadi radia
  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  void navigateToAddAddressPage(
      BuildContext context,
      String currentAddress,
      double haversineDistanceText,
      String manhattanDistanceText,
      String euclideanDistanceText,
      double titikLat,
      double titikLong) {
    context.goNamed(
      RouteConstants.addAddress,
      pathParameters: PathParameters(
        rootTab: RootTab.order,
      ).toMap(),
      extra: {
        'currentAddress': currentAddress,
        'haversineDistanceText': haversineDistanceText,
        'manhattanDistanceText': manhattanDistanceText,
        'euclideanDistanceText': euclideanDistanceText,
        'titikLat': titikLat,
        'titikLong': titikLong,
      },
    );
  }
}
