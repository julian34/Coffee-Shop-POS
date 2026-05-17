import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  const SessionManager._();

  static const String _uidKey = 'uid';
  static const String _nameKey = 'name';
  static const String _emailKey = 'email';
  static const String _roleKey = 'role';
  static const String _approvedKey = 'approved';
  static const String _activeKey = 'active';

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

    await prefs.remove(_uidKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_approvedKey);
    await prefs.remove(_activeKey);
  }
}
