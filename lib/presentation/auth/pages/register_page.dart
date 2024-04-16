import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/core.dart';
import '../../../core/router/app_router.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../../../data/models/requests/register_request_model.dart';
import '../bloc/register/register_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
              QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: 'Berhasil membuat akun!',
                onConfirmBtnTap: () {
                  context.goNamed(RouteConstants.login);
                },
              );
            },
            error: (message) {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: "Terjadi Kesalahan",
                text: message,
              );
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
                    onPressed: () {
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
                      } else if (!isEmailValid(emailController.text)) {
                        // Validasi agar email mengandung "@" dan "."
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Terjadi Kesalahan",
                          text: 'Email tidak valid',
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
                          final dataRequest = RegisterRequestModel(
                            name: usernameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                          );

                          context
                              .read<RegisterBloc>()
                              .add(RegisterEvent.register(dataRequest));
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
                        style: TextStyle(color: AppColors.mainTextColor),
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

  // Fungsi untuk memeriksa apakah email valid menggunakan RegExp
  bool isEmailValid(String email) {
    final RegExp regex = RegExp(r'[@.]');
    return regex.hasMatch(email);
  }
}
