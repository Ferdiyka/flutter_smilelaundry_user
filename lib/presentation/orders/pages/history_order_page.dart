import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesanan'),
        actions: [
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
                child: Text('No Data'),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (historyOrderResponseModel) {
              if (historyOrderResponseModel.orders!.isEmpty) {
                return const Center(
                  child: Text('No Data'),
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
