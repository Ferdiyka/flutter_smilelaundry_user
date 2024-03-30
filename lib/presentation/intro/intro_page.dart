import 'package:flutter/material.dart';
import 'package:flutter_smilelaundry_user/core/router/app_router.dart';
import 'package:go_router/go_router.dart';

import '../../core/assets/assets.gen.dart';
import '../../core/components/buttons.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Introduction'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.images.intro1
                        .path, // Replace with your 'pick_up.png' image asset path
                    height: 200,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Pick up',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pesan lewat aplikasi kemudian pilih tanggal pick up, kami akan menjemput pakaianmu',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 50.0), // Adjust this value as needed
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 350, // Set the desired width
                  child: Button.filled(
                    onPressed: () {
                      // Navigate to the next intro page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IntroPage2(),
                        ),
                      );
                    },
                    label: 'Continue',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Replace this with your next intro page widget
class IntroPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Introduction'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.images.intro2
                        .path, // Replace with your 'pick_up.png' image asset path
                    height: 200,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Wash',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Setelah pakaianmu dijemput kami akan segera mencuci pakaianmu hingga bersih',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 50.0), // Adjust this value as needed
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 350, // Set the desired width
                  child: Button.filled(
                    onPressed: () {
                      // Navigate to the next intro page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IntroPage3(),
                        ),
                      );
                    },
                    label: 'Continue',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IntroPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Introduction'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.images.intro3
                        .path, // Replace with your 'pick_up.png' image asset path
                    height: 200,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Delivery & COD',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Setelah pakaianmu selesai, kami akan mengirim notifikasi tagihan dan kami akan mengantar pakaianmu',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 50.0), // Adjust this value as needed
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 350, // Set the desired width
                  child: Button.filled(
                    onPressed: () {
                      // Navigate to home page
                      context.goNamed(
                        RouteConstants.root,
                        pathParameters: PathParameters().toMap(),
                      );
                    },
                    label: 'Continue',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}