// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smilelaundry_user/data/datasources/auth_local_datasource.dart';
import 'package:flutter_smilelaundry_user/data/datasources/firebase_messanging_remote_datasource.dart';
import 'package:flutter_smilelaundry_user/presentation/auth/bloc/login/login_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/quickalert.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/core.dart';
import '../../../core/router/app_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const SpaceHeight(100.0),
          const Text(
            'Login Account',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SpaceHeight(50.0),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email ID',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Assets.icons.email.svg(),
              ),
            ),
          ),
          const SpaceHeight(20.0),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Assets.icons.password.svg(),
              ),
            ),
          ),
          const SpaceHeight(50.0),
          BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                loaded: (data) async {
                  await FirebaseMessagingRemoteDatasource().initialize();
                  try {
                    // Sign in the user with Firebase Auth
                    UserCredential userCredential =
                        await _auth.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );

                    // Check if the user's email is verified
                    if (!userCredential.user!.emailVerified) {
                      // Show an error message if the email is not verified
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: "Terjadi Kesalahan",
                        text:
                            'Email Anda belum terverifikasi. Silakan cek email Anda2.',
                      );
                      return;
                    }
                    AuthLocalDatasource().saveAuthData(data);
                    await FirebaseMessagingRemoteDatasource().initialize();
                    context.goNamed(
                      RouteConstants.root,
                      pathParameters: PathParameters().toMap(),
                    );
                  } catch (e) {
                    // Handle login error
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: "Terjadi Kesalahan",
                      text:
                          "Email Anda belum terverifikasi. Silakan cek email Anda3.",
                    );
                  }
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
              return state.maybeWhen(
                orElse: () {
                  return Button.filled(
                    onPressed: () async {
                      // Validasi email dan password
                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.error,
                          title: "Terjadi Kesalahan",
                          text: 'Email dan Password harus diisi',
                        );
                      } else {
                        context.read<LoginBloc>().add(
                              LoginEvent.login(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                      }
                    },
                    label: 'Login',
                  );
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            },
          ),
          const SpaceHeight(50.0),
          GestureDetector(
            onTap: () {
              context.goNamed(RouteConstants.register);
            },
            child: const Text.rich(
              TextSpan(
                text: 'Belum punya akun?',
                children: [
                  TextSpan(
                    text: ' Register',
                    style: TextStyle(color: AppColors.mainTextColor),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
