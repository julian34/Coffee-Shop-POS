import 'package:flutter/material.dart';

import 'package:pos_coffee_shop/models/order_model.dart';
import 'package:pos_coffee_shop/models/payment_model.dart';

import 'package:pos_coffee_shop/screens/auth/login_screen.dart';
import 'package:pos_coffee_shop/screens/cart/cart_screen.dart';
import 'package:pos_coffee_shop/screens/error_screen.dart';
import 'package:pos_coffee_shop/screens/home/cashier_screen.dart';
import 'package:pos_coffee_shop/screens/home/manager_screen.dart';
import 'package:pos_coffee_shop/screens/home/owner_screen.dart';
import 'package:pos_coffee_shop/screens/setting/profile_screen.dart';
import 'package:pos_coffee_shop/screens/splash_screen.dart';
import 'package:pos_coffee_shop/screens/transaction/order_detail_screen.dart';
import 'package:pos_coffee_shop/screens/transaction/orders_screen.dart';
import 'package:pos_coffee_shop/screens/transaction/payment_screen.dart';
import 'package:pos_coffee_shop/screens/transaction/success_screen.dart';

class AppRoutes {
  const AppRoutes._();

  // =========================================================
  // Initial & Authentication Routes
  // =========================================================
  static const String splash = '/';
  static const String login = '/login';

  // =========================================================
  // Role-Based Home Routes
  // =========================================================
  static const String ownerHome = '/owner-home';
  static const String managerHome = '/manager-home';
  static const String cashierHome = '/cashier-home';

  // =========================================================
  // Transaction Routes
  // =========================================================
  static const String cart = '/cart';
  static const String order = '/order';
  static const String orderDetail = '/order-detail';
  static const String payment = '/payment';
  static const String successPayment = '/success-payment';

  // Alias agar kode lama yang masih memakai successpayment tidak error.
  static const String successpayment = successPayment;

  // =========================================================
  // User & Utility Routes
  // =========================================================
  static const String profile = '/profile';
  static const String error = '/error';

  // =========================================================
  // Route Generator
  // =========================================================
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // -----------------------------------------------------
      // Splash
      // -----------------------------------------------------
      case splash:
        return _buildRoute(settings: settings, page: SplashScreen());

      // -----------------------------------------------------
      // Login
      // -----------------------------------------------------
      case login:
        return _buildRoute(settings: settings, page: LoginScreen());

      // -----------------------------------------------------
      // Owner Home
      // -----------------------------------------------------
      case ownerHome:
        return _buildRoute(settings: settings, page: OwnerHomeScreen());

      // -----------------------------------------------------
      // Manager Home
      // -----------------------------------------------------
      case managerHome:
        return _buildRoute(settings: settings, page: ManagerHomeScreen());

      // -----------------------------------------------------
      // Cashier Home
      // Argument OrderList bersifat optional.
      // Halaman ini bisa dibuka dengan order atau tanpa order.
      // -----------------------------------------------------
      case cashierHome:
        final OrderList? orderArgument = _getOrderArgument(
          settings,
          routeName: cashierHome,
          isRequired: false,
        );

        return _buildRoute(
          settings: settings,
          page: CashierHomeScreen(order: orderArgument),
        );

      // -----------------------------------------------------
      // Profile
      // -----------------------------------------------------
      case profile:
        return _buildRoute(settings: settings, page: ProfileScreen());

      // -----------------------------------------------------
      // Cart
      // Argument OrderList bersifat optional.
      // Jika membuka cart dari pending order, argument diisi.
      // Jika membuka cart biasa, argument boleh null.
      // -----------------------------------------------------
      case cart:
        final OrderList? orderArgument = _getOrderArgument(
          settings,
          routeName: cart,
          isRequired: false,
        );

        return _buildRoute(
          settings: settings,
          page: CartScreen(order: orderArgument),
        );

      // -----------------------------------------------------
      // Order List
      // -----------------------------------------------------
      case order:
        return _buildRoute(settings: settings, page: OrdersScreen());

      // -----------------------------------------------------
      // Order Detail
      // Argument OrderList wajib ada.
      // -----------------------------------------------------
      case orderDetail:
        final OrderList? orderArgument = _getOrderArgument(
          settings,
          routeName: orderDetail,
          isRequired: true,
        );

        if (orderArgument == null) {
          return _errorRoute(
            settings: settings,
            message: 'Argument untuk halaman Order Detail tidak valid.',
          );
        }

        return _buildRoute(
          settings: settings,
          page: OrderDetailScreen(order: orderArgument),
        );

      // -----------------------------------------------------
      // Payment
      // Argument OrderList wajib ada.
      // PaymentScreen membutuhkan data order.
      // -----------------------------------------------------
      case payment:
        final OrderList? orderArgument = _getOrderArgument(
          settings,
          routeName: payment,
          isRequired: true,
        );

        if (orderArgument == null) {
          return _errorRoute(
            settings: settings,
            message: 'Argument untuk halaman Payment tidak valid.',
          );
        }

        return _buildRoute(
          settings: settings,
          page: PaymentScreen(orderList: orderArgument),
        );

      // -----------------------------------------------------
      // Success Payment
      // Argument Payment wajib ada.
      // -----------------------------------------------------
      case successPayment:
        final Payment? paymentArgument = _getPaymentArgument(
          settings,
          routeName: successPayment,
          isRequired: true,
        );

        if (paymentArgument == null) {
          return _errorRoute(
            settings: settings,
            message: 'Argument untuk halaman Success Payment tidak valid.',
          );
        }

        return _buildRoute(
          settings: settings,
          page: SuccessScreen(payment: paymentArgument),
        );

      // -----------------------------------------------------
      // Error
      // Argument String bersifat optional.
      // -----------------------------------------------------
      case error:
        final String? messageArgument = _getStringArgument(
          settings,
          routeName: error,
          isRequired: false,
        );

        return _errorRoute(
          settings: settings,
          message: messageArgument ?? 'Terjadi kesalahan pada aplikasi.',
        );

      // -----------------------------------------------------
      // Unknown Route
      // -----------------------------------------------------
      default:
        return _errorRoute(
          settings: settings,
          message: 'Page Not Found: ${settings.name}',
        );
    }
  }

  // =========================================================
  // Build Standard Route
  // =========================================================
  static MaterialPageRoute<dynamic> _buildRoute({
    required RouteSettings settings,
    required Widget page,
  }) {
    return MaterialPageRoute(settings: settings, builder: (_) => page);
  }

  // =========================================================
  // Build Error Route
  // =========================================================
  static MaterialPageRoute<dynamic> _errorRoute({
    required RouteSettings settings,
    required String message,
  }) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => ErrorScreen(message: message),
    );
  }

  // =========================================================
  // Get OrderList Argument
  // =========================================================
  static OrderList? _getOrderArgument(
    RouteSettings settings, {
    required String routeName,
    required bool isRequired,
  }) {
    final Object? args = settings.arguments;

    if (args == null) {
      if (isRequired) {
        debugPrint(
          'Route $routeName membutuhkan argument OrderList, tetapi argument null.',
        );
      }

      return null;
    }

    if (args is OrderList) {
      return args;
    }

    debugPrint(
      'Argument untuk route $routeName tidak valid. '
      'Expected OrderList, but got ${args.runtimeType}.',
    );

    return null;
  }

  // =========================================================
  // Get Payment Argument
  // =========================================================
  static Payment? _getPaymentArgument(
    RouteSettings settings, {
    required String routeName,
    required bool isRequired,
  }) {
    final Object? args = settings.arguments;

    if (args == null) {
      if (isRequired) {
        debugPrint(
          'Route $routeName membutuhkan argument Payment, tetapi argument null.',
        );
      }

      return null;
    }

    if (args is Payment) {
      return args;
    }

    debugPrint(
      'Argument untuk route $routeName tidak valid. '
      'Expected Payment, but got ${args.runtimeType}.',
    );

    return null;
  }

  // =========================================================
  // Get String Argument
  // =========================================================
  static String? _getStringArgument(
    RouteSettings settings, {
    required String routeName,
    required bool isRequired,
  }) {
    final Object? args = settings.arguments;

    if (args == null) {
      if (isRequired) {
        debugPrint(
          'Route $routeName membutuhkan argument String, tetapi argument null.',
        );
      }

      return null;
    }

    if (args is String) {
      return args;
    }

    debugPrint(
      'Argument untuk route $routeName tidak valid. '
      'Expected String, but got ${args.runtimeType}.',
    );

    return null;
  }
}
