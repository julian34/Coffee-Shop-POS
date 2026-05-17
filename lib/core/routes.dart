import 'package:flutter/material.dart';

import 'package:pos_coffee_shop/models/order_model.dart';
import 'package:pos_coffee_shop/models/payment_model.dart';

import 'package:pos_coffee_shop/screens/auth/login_screen.dart';
import 'package:pos_coffee_shop/screens/home/cashier_screen.dart';
import 'package:pos_coffee_shop/screens/home/manager_screen.dart';
import 'package:pos_coffee_shop/screens/home/owner_screen.dart';
import 'package:pos_coffee_shop/screens/splash_screen.dart';
import 'package:pos_coffee_shop/screens/error_screen.dart';
import 'package:pos_coffee_shop/screens/setting/profile_screen.dart';
import 'package:pos_coffee_shop/screens/cart/cart_screen.dart';
import 'package:pos_coffee_shop/screens/transaction/orders_screen.dart';
import 'package:pos_coffee_shop/screens/transaction/order_detail_screen.dart';
import 'package:pos_coffee_shop/screens/transaction/payment_screen.dart';
import 'package:pos_coffee_shop/screens/transaction/success_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';

  static const String ownerHome = '/owner-home';
  static const String managerHome = '/manager-home';
  static const String cashierHome = '/cashier-home';

  static const String cart = '/cart';
  static const String order = '/order';
  static const String payment = '/payment';
  static const String successpayment = '/success-payment';
  static const String orderDetail = '/order-detail';

  static const String error = '/error';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case ownerHome:
        return MaterialPageRoute(builder: (_) => OwnerHomeScreen());

      case managerHome:
        return MaterialPageRoute(builder: (_) => ManagerHomeScreen());

      case cashierHome:
        final OrderList? order = settings.arguments as OrderList?;
        return MaterialPageRoute(
          builder: (_) => CashierHomeScreen(order: order),
        );

      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());

      case cart:
        final OrderList? order = settings.arguments as OrderList?;
        return MaterialPageRoute(builder: (_) => CartScreen(order: order));

      case order:
        return MaterialPageRoute(builder: (_) => OrdersScreen());

      case orderDetail:
        final Object? args = settings.arguments;

        if (args is! OrderList) {
          return _errorRoute(
            'Argument untuk halaman Order Detail tidak valid.',
          );
        }

        return MaterialPageRoute(
          builder: (_) => OrderDetailScreen(order: args),
        );

      case payment:
        final Object? args = settings.arguments;

        if (args is! OrderList) {
          return _errorRoute('Argument untuk halaman Payment tidak valid.');
        }

        return MaterialPageRoute(
          builder: (_) => PaymentScreen(orderList: args),
        );

      case successpayment:
        final Object? args = settings.arguments;

        if (args is! Payment) {
          return _errorRoute(
            'Argument untuk halaman Success Payment tidak valid.',
          );
        }

        return MaterialPageRoute(builder: (_) => SuccessScreen(payment: args));

      default:
        return _errorRoute('Page Not Found: ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(builder: (_) => ErrorScreen(message: message));
  }
}
