import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  const SessionManager._();

  static const String _roleKey = 'role';

  static Future<String?> getSavedRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  static Future<void> saveRole(String role) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
  }

  static Future<void> clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_roleKey);
  }
}
