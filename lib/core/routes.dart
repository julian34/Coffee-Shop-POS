import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/auth/login_screen.dart';
// import '../screens/auth/register_screen.dart';
import '../screens/home/cashier_screen.dart';
import '../screens/home/manager_screen.dart';
import '../screens/home/owner_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/error_screen.dart';
import '../screens/setting/profile_screen.dart';
import '../screens/cart/cart_screen.dart';

import 'package:pos_coffee_shop/screens/transaction/orders_screen.dart';
import 'package:pos_coffee_shop/screens/transaction/order_detail_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  // static const String register = '/register';
  static const String ownerHome = '/owner-home';
  static const String managerHome = '/manager-home';
  static const String cashierHome = '/cashier-home';

  static const String cart = '/cart';
  static const String order = '/order';
  static const String orderDetail = '/order-detail';

  static const String error = '/error';
  static const String profile = '/profile';

  // Determine the initial route based on saved role
  static Future<String> getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedRole = prefs.getString('role');
    if (savedRole == "Owner") return ownerHome;
    if (savedRole == "Manager") return managerHome;
    if (savedRole == "Cashier") return cashierHome;
    return login;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      // case register:
      //   return MaterialPageRoute(builder: (_) => RegisterScreen());
      case ownerHome:
        return MaterialPageRoute(builder: (_) => OwnerHomeScreen());
      case managerHome:
        return MaterialPageRoute(builder: (_) => ManagerHomeScreen());
      case cashierHome:
        final order = settings.arguments as OrderList;
        if (order != null) {
          return MaterialPageRoute(
            builder: (_) => CashierHomeScreen(order: order),
          );
        }
        return MaterialPageRoute(builder: (_) => CashierHomeScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case cart:
        final order = settings.arguments as OrderList;
        return MaterialPageRoute(builder: (_) => CartScreen(order: order));
      case order:
        return MaterialPageRoute(builder: (_) => OrdersScreen());
      case orderDetail:
        final order = settings.arguments as OrderList; // Extract argument
        return MaterialPageRoute(
          builder: (_) => OrderDetailScreen(order: order),
        );

      default:
        return MaterialPageRoute(
          builder:
              (_) => ErrorScreen(message: 'Page Not Found: ${settings.name}'),
        );
    }
  }
}
