import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/responses/product_response_model.dart';
import '../../presentation/home/pages/dashboard_page.dart';
import '../../presentation/home/pages/product_detail_page.dart';
import '../../presentation/intro/intro_page.dart';
import '../../presentation/intro/splash_page.dart';

part 'route_constants.dart';
part 'enums/root_tab.dart';
part 'models/path_parameters.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: RouteConstants.splashPath,
    routes: [
      GoRoute(
        name: RouteConstants.splash,
        path: RouteConstants.splashPath,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        name: RouteConstants.intro,
        path: RouteConstants.introPath,
        builder: (context, state) => const IntroPage(),
      ),
      GoRoute(
        name: RouteConstants.productDetail,
        path: RouteConstants.productDetailPath,
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          final data = state.extra
              as Product; // Get the data object from the extra parameter
          return ProductDetailPage(
            productId: productId,
            data: data,
          );
        },
      ),
      GoRoute(
        name: RouteConstants.root,
        path: RouteConstants.rootPath,
        builder: (context, state) {
          final tab = int.tryParse(state.pathParameters['root_tab'] ?? '') ?? 0;
          return DashboardPage(
            key: state.pageKey,
            currentTab: tab,
          );
        },
      ),
    ],
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(
              state.error.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    },
  );
}
