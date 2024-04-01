import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/responses/product_response_model.dart';
import '../../presentation/auth/pages/login_page.dart';
import '../../presentation/auth/pages/register_page.dart';
import '../../presentation/home/pages/dashboard_page.dart';
import '../../presentation/home/pages/product_detail_page.dart';
import '../../presentation/intro/intro_page.dart';
import '../../presentation/intro/splash_page.dart';
import '../../presentation/orders/pages/cart_page.dart';
import '../../presentation/orders/pages/order_detail_page.dart';

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
        name: RouteConstants.login,
        path: RouteConstants.loginPath,
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            name: RouteConstants.register,
            path: RouteConstants.registerPath,
            builder: (context, state) => const RegisterPage(),
          ),
        ],
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
        routes: [
          GoRoute(
              name: RouteConstants.cart,
              path: RouteConstants.cartPath,
              builder: (context, state) => const CartPage(),
              routes: [
                GoRoute(
                  name: RouteConstants.orderDetail,
                  path: RouteConstants.orderDetailPath,
                  builder: (context, state) => const OrderDetailPage(),
                  // routes: [
                  //   GoRoute(
                  //     name: RouteConstants.paymentDetail,
                  //     path: RouteConstants.paymentDetailPath,
                  //     builder: (context, state) => const PaymentDetailPage(),
                  //     routes: [
                  //       GoRoute(
                  //         name: RouteConstants.trackingOrder,
                  //         path: RouteConstants.trackingOrderPath,
                  //         builder: (context, state) => const TrackingOrderPage(),
                  //         routes: [
                  //           GoRoute(
                  //             name: RouteConstants.shippingDetail,
                  //             path: RouteConstants.shippingDetailPath,
                  //             builder: (context, state) =>
                  //                 const ShippingDetailPage(),
                  //           ),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ],
                ),
              ]),
        ],
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
