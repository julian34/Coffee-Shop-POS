import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../core/routes.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null && _user!.active;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _loadUserFromPrefs();
    _authService.authInstance.authStateChanges().listen(
      (User? firebaseUser) async {
        if (firebaseUser != null) {
          _user = await _authService.getUserData(firebaseUser.uid);
          if (_user != null && !_user!.active) {
            await _authService.signOut();
            _user = null;
            _errorMessage = "Your account is disabled.";
          } else {
            _saveUserToPrefs(_user!);
          }
        } else {
          _user = null;
          _clearPrefs();
        }
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = "Auth state error: ${error.toString()}";
        notifyListeners();
      },
    );
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      _errorMessage = null;
      _user = await _authService.signInWithEmail(email, password);
      if (_user == null || !_user!.active) {
        return "Your account is disabled.";
      }
      if (_user != null) {
        await saveUserRole(_user!.role); // Save role for session persistence
      }
      _saveUserToPrefs(_user!);
      notifyListeners();
      // print(
      //   "1. User signed in: ${_user?.name}, Role: ${_user?.role}",
      // ); // Debugging
      return null; // Success
    } on Exception catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return _errorMessage;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _errorMessage = null;
    await _clearPrefs();
    notifyListeners();
  }

  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }

  // ✅ Save user session
  Future<void> _saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', user.uid);
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('role', user.role);
    await prefs.setBool('approved', user.approved);
    await prefs.setBool('active', user.active);
  }

  // ✅ Load user session
  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('uid')) {
      _user = UserModel(
        uid: prefs.getString('uid')!,
        name: prefs.getString('name')!,
        email: prefs.getString('email')!,
        role: prefs.getString('role')!,
        approved: prefs.getBool('approved')!,
        active: prefs.getBool('active')!,
      );
      notifyListeners();
    }
  }

  // ✅ Clear session on logout
  Future<void> _clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Enable/Disable User
  Future<void> updateUserStatus(String uid, bool activeStatus) async {
    await _authService.updateUserStatus(uid, activeStatus);
    if (_user != null && _user!.uid == uid) {
      _user = UserModel(
        uid: _user!.uid,
        name: _user!.name,
        email: _user!.email,
        role: _user!.role,
        approved: _user!.approved,
        active: activeStatus,
      );
      notifyListeners();
    }
  }

  void navigateBasedOnRole(BuildContext context, String role) {
    print("navbaseonrole: ${_user?.name}, Role: ${_user?.role}"); // Debugging
    if (_user == null) return;
    if (_user!.role == "Owner") {
      Navigator.pushReplacementNamed(context, AppRoutes.ownerHome);
    } else if (role == "Manager") {
      Navigator.pushReplacementNamed(context, AppRoutes.managerHome);
    } else {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.cashierHome,
        arguments: OrderList(
          cartId: '',
          customerName: '',
          totalAmount: 0,
          paid: false,
          isPaid: false,
          paymentMode: 'Cash',
          status: 'Pending',
          createdAt: DateTime.timestamp(),
          items: [],
        ),
      );
    }
  }
}
