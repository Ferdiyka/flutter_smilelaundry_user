import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/core.dart';
import '../../../core/router/app_router.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../bloc/register/register_bloc.dart';
import 'verification_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Register'),
      ),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            success: (state) {
              AuthLocalDatasource().saveAuthData(state);
            },
          );
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              CustomTextField(
                controller: usernameController,
                label: 'Nama',
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: emailController,
                label: 'Email Address',
              ),
              const Text(
                'Pastikan Anda menggunakan email yang asli',
                style: TextStyle(
                  fontSize: 10,
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: passwordController,
                label: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: confirmPasswordController,
                label: 'Confirm Password',
                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              state.maybeWhen(
                orElse: () {
                  return Button.filled(
                    onPressed: () async {
                      // Validasi agar semua input harus diisi sebelum registrasi
                      if (usernameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          passwordController.text.isEmpty ||
                          confirmPasswordController.text.isEmpty) {
                        // Menampilkan pesan peringatan jika ada input yang kosong
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Terjadi Kesalahan",
                          text: 'Semua input harus diisi',
                        );
                      } else {
                        // Validasi agar password dan konfirmasi password sama
                        if (passwordController.text !=
                            confirmPasswordController.text) {
                          // Menampilkan pesan peringatan jika password tidak cocok
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: "Terjadi Kesalahan",
                            text:
                                'Password dan konfirmasi password tidak cocok',
                          );
                        } else {
                          try {
                            // Create the user with Firebase Auth
                            UserCredential userCredential =
                                await _auth.createUserWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );

                            // Send email verification
                            await userCredential.user!.sendEmailVerification();

                            // Show success message and navigate to the login page

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerificationPage(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: usernameController.text,
                                ),
                              ),
                            );
                          } catch (e) {
                            // Handle registration error
                            String errorMessage = 'Terjadi Kesalahan';
                            if (e is FirebaseAuthException) {
                              errorMessage = e.message ?? errorMessage;
                            } else {
                              errorMessage = e.toString();
                            }

                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              title: "Terjadi Kesalahan",
                              text: errorMessage,
                            );
                          }
                        }
                      }
                    },
                    label: 'Register',
                  );
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              const SizedBox(height: 24.0),
              GestureDetector(
                onTap: () {
                  context.goNamed(RouteConstants.login);
                },
                child: const Text.rich(
                  TextSpan(
                    text: 'Sudah punya akun? ',
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(color: AppColors.mainColor),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
