import 'package:pos_coffee_shop/core/enums/user_role.dart';
import 'package:pos_coffee_shop/core/routes.dart';
import 'package:pos_coffee_shop/core/session/session_manager.dart';

class InitialRouteResolver {
  const InitialRouteResolver._();

  static Future<String> resolve() async {
    final String? savedRole = await SessionManager.getSavedRole();
    final UserRole role = UserRole.fromString(savedRole);

    switch (role) {
      case UserRole.owner:
        return AppRoutes.ownerHome;
      case UserRole.manager:
        return AppRoutes.managerHome;
      case UserRole.cashier:
        return AppRoutes.cashierHome;
      case UserRole.unknown:
        return AppRoutes.login;
    }
  }
}
