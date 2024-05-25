// ignore_for_file: use_super_parameters, use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';
import '../../../core/components/spaces.dart';
import '../../../data/datasources/auth_local_datasource.dart';
import '../bloc/history/history_bloc.dart';
import '../widgets/order_card.dart';

class HistoryOrderPage extends StatefulWidget {
  const HistoryOrderPage({Key? key}) : super(key: key);

  @override
  State<HistoryOrderPage> createState() => _HistoryOrderPageState();
}

class _HistoryOrderPageState extends State<HistoryOrderPage> {
  final _authLocalDatasource = AuthLocalDatasource();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    _subscribeToFCMNotifications();
  }

  void _subscribeToFCMNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleFCMNotification();
    });
  }

  void _handleFCMNotification() {
    // Update the HistoryBloc when a notification is received
    context.read<HistoryBloc>().add(const HistoryEvent.getHistoryOrder());
  }

  Future<void> _checkAuthStatus() async {
    final isAuth = await _authLocalDatasource.isAuth();
    if (isAuth) {
      context.read<HistoryBloc>().add(const HistoryEvent.getHistoryOrder());
    } else {
      // Display "No Data"
    }
  }

  @override
  void dispose() {
    // Cancel the FCM notification stream subscription
    FirebaseMessaging.onMessage.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Order'),
        actions: [
          IconButton(
            onPressed: () {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.info,
                text:
                    'Gunakan tombol refresh untuk melihat update terbaru dari pesanan Anda',
              );
            },
            icon: const Icon(Icons
                .info_outline), // Menggunakan widget Icon untuk menampilkan ikon
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkAuthStatus,
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () {
              return const Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 25), // Ubah nilai sesuai kebutuhan Anda
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No Data'),
                        SizedBox(height: 8),
                        Text(
                          'Pastikan Anda sudah login atau coba tekan tombol refresh',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (historyOrderResponseModel) {
              if (historyOrderResponseModel.orders!.isEmpty) {
                return const Center(
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25), // Ubah nilai sesuai kebutuhan Anda
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No Data'),
                          SizedBox(height: 8),
                          Text(
                            'Pastikan Anda sudah login atau coba tekan tombol refresh',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16.0),
                separatorBuilder: (context, index) => const SpaceHeight(16.0),
                itemCount: historyOrderResponseModel.orders!.length,
                itemBuilder: (context, index) {
                  final orderElement = historyOrderResponseModel.orders![index];
                  return OrderCard(
                    data: orderElement.order!,
                    products: orderElement.products!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
