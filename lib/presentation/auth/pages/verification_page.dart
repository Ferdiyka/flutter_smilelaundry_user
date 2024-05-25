// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';

import '../../../core/components/spaces.dart';
import '../../../core/router/app_router.dart';
import '../bloc/register/register_bloc.dart';
import '../../../data/models/requests/register_request_model.dart';

class VerificationPage extends StatefulWidget {
  final String email;
  final String password;
  final String name;

  const VerificationPage({
    Key? key,
    required this.email,
    required this.password,
    required this.name,
  }) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage>
    with SingleTickerProviderStateMixin {
  bool isVerified = false;
  bool isExpired =
      false; // Menandakan apakah waktu verifikasi sudah kedaluwarsa
  int remainingTime = 60;
  late Timer _timer;
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _startTimer();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: remainingTime),
    );
    animation = Tween<double>(
      begin: remainingTime.toDouble(),
      end: 0,
    ).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    _startAnimation();
  }

  @override
  void dispose() {
    _timer.cancel();
    animationController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingTime > 0) {
        remainingTime--;
        if (remainingTime == 0) {
          setState(() {
            isExpired = true;
          });
        }
      }
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        if (user.emailVerified) {
          setState(() {
            isVerified = true;
          });
          _timer
              .cancel(); // Navigasi ke halaman home setelah verifikasi email berhasil
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text:
                'Email berhasil diverifikasi!. Silakan login dengan email yang sudah Anda buat',
            onConfirmBtnTap: () {
              context.goNamed(RouteConstants.login);
              _createDataToDatabase();
            },
          );
        } else if (isExpired) {
          // Cek verifikasi email meskipun timer sudah habis
          await user.reload();
          if (user.emailVerified) {
            setState(() {
              isVerified = true;
            });
            _timer.cancel();
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text:
                  'Email berhasil diverifikasi!. Silakan login dengan email yang sudah Anda buat',
              onConfirmBtnTap: () {
                context.goNamed(RouteConstants.login);
                _createDataToDatabase();
              },
            );
          }
        }
      }
    });
  }

  void _startAnimation() {
    animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Email verifikasi telah dikirim, silakan cek email Anda termasuk folder spam',
                textAlign: TextAlign.center,
              ),
              const SpaceHeight(30.0),
              if (!isVerified && !isExpired)
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Text(
                      'Kirim ulang verifikasi email dalam ${animation.value.toInt()}detik',
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              if (isExpired)
                ElevatedButton(
                  onPressed:
                      _resendVerificationEmail, // Panggil method saat tombol ditekan
                  child: const Text('Resend Verification Email'),
                ),
              const SpaceHeight(30.0),
              const Text(
                'Pastikan Anda tidak menutup aplikasi ini secara keseluruhan saat melakukan verifikasi email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createDataToDatabase() {
    final dataRequest = RegisterRequestModel(
      name: widget.name,
      email: widget.email,
      password: widget.password,
    );

    context.read<RegisterBloc>().add(RegisterEvent.register(dataRequest));
  }

  // Method untuk mengirim ulang email verifikasi
  void _resendVerificationEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user.sendEmailVerification();
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        text:
            'Email verifikasi baru telah dikirim ulang. Silakan periksa inbox Anda.',
      );
      // Mulai ulang timer
      setState(() {
        isExpired = false;
        remainingTime = 60;
      });
      _startTimer();
      _startAnimation();
    }
  }
}
