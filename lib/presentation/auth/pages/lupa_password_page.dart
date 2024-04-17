// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';

import '../../../core/router/app_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isNotEmpty) {
      try {
        await _auth.sendPasswordResetEmail(email: email);
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Password Reset Email Sent',
            text: 'Please check your inbox.',
            onConfirmBtnTap: () {
              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.info,
                  title: 'Go to Login Page?',
                  text:
                      'Pastikan Anda sudah mengecek email reset password dan sudah mengubah password Anda sebelum kembali ke halaman Login',
                  onConfirmBtnTap: () {
                    context.goNamed(RouteConstants.login);
                  });
            });
      } catch (e) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to send password reset email. Please try again.',
        );
      }
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.info,
        title: 'Error',
        text: 'Please enter your email address.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _resetPassword,
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
