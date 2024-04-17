import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';

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

class _VerificationPageState extends State<VerificationPage> {
  bool isVerified = false;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        if (user.emailVerified) {
          setState(() {
            isVerified = true;
          });
          _timer.cancel();
          // Navigasi ke halaman home setelah verifikasi email berhasil
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Email'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Email verifikasi telah dikirim, silakan cek email Anda termasuk folder spam',
              textAlign: TextAlign.center,
            ),
          ],
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
}
