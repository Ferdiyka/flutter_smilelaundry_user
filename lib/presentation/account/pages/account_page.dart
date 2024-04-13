// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../auth/bloc/logout/logout_bloc.dart';
import '../../../../data/datasources/auth_local_datasource.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _isLoggedIn = false;
  String? _userName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authLocalDataSource = AuthLocalDatasource();
    final isAuthenticated = await authLocalDataSource.isAuth();
    final userName = await authLocalDataSource.getUserName();
    setState(() {
      _isLoggedIn = isAuthenticated;
      _userName = userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _isLoggedIn
              ? _buildLoggedInContent(context)
              : _buildLoggedOutContent(context),
        ),
      ),
    );
  }

  List<Widget> _buildLoggedInContent(BuildContext context) {
    return [
      if (_userName != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Welcome, $_userName',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
      ElevatedButton(
        onPressed: () {
          context.goNamed(
            RouteConstants.aboutPage,
            pathParameters: PathParameters().toMap(),
          );
        },
        child: const Text('About Us'),
      ),
      ElevatedButton(
        onPressed: () async {
          await AuthLocalDatasource().removeAuthData();
          context.read<LogoutBloc>().add(const LogoutEvent.logout());
          setState(() {
            _isLoggedIn = false;
            _userName = null;
          });
          context.goNamed(
            RouteConstants.login,
          );
        },
        child: const Text('Logout'),
      ),
    ];
  }

  List<Widget> _buildLoggedOutContent(BuildContext context) {
    return [
      ElevatedButton(
        onPressed: () {
          context.goNamed(
            RouteConstants.login,
          );
        },
        child: const Text('Login'),
      ),
    ];
  }
}
