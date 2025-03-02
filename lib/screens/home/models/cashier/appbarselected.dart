import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/routes.dart';
import '../../../../providers/auth_provider.dart';

void AppBarSelectItem(
  BuildContext context,
  item,
  AuthProvider authProvider,
) async {
  switch (item) {
    case 0:
      print("Profile");
      Navigator.of(context).pushNamed(AppRoutes.profile);
      break;
    case 1:
      print("Logging out");
      await authProvider.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('role');
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      break;
    default:
      print("Incalid Selection");
  }
}
