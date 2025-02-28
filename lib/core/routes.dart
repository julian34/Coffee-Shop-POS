import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
// import '../screens/auth/register_screen.dart';
import '../screens/home/cashier_screen.dart';
import '../screens/home/manager_screen.dart';
import '../screens/home/owner_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/error_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  // static const String register = '/register';
  static const String ownerHome = '/owner-home';
  static const String managerHome = '/manager-home';
  static const String cashierHome = '/cashier-home';
  static const String error = '/error';

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
        return MaterialPageRoute(builder: (_) => CashierHomeScreen());
      default:
        return MaterialPageRoute(
          builder:
              (_) => ErrorScreen(message: 'Page Not Found: ${settings.name}'),
        );
    }
  }
}
