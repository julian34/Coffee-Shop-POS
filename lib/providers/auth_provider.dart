import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/models/order_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/routes.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  String? _errorMessage;

  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _user != null && _user!.active;

  AuthProvider() {
    _loadUserFromPrefs();

    _authService.authInstance.authStateChanges().listen(
      (User? firebaseUser) async {
        if (firebaseUser != null) {
          _user = await _authService.getUserData(firebaseUser.uid);

          if (_user == null) {
            _errorMessage = 'User data not found.';
            await _clearPrefs();
          } else if (!_user!.active) {
            await _authService.signOut();
            _user = null;
            _errorMessage = 'Your account is disabled.';
            await _clearPrefs();
          } else {
            await _saveUserToPrefs(_user!);
          }
        } else {
          _user = null;
          await _clearPrefs();
        }

        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Auth state error: ${error.toString()}';
        notifyListeners();
      },
    );
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      _errorMessage = null;

      _user = await _authService.signInWithEmail(email, password);

      if (_user == null) {
        return 'User profile not found.';
      }

      if (!_user!.active) {
        await _clearPrefs();
        _user = null;
        return 'Your account is disabled.';
      }

      await _saveUserToPrefs(_user!);
      notifyListeners();

      return null;
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

  Future<void> _saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('uid', user.uid);
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('role', user.role);
    await prefs.setBool('approved', user.approved);
    await prefs.setBool('active', user.active);
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final uid = prefs.getString('uid');
    final name = prefs.getString('name');
    final email = prefs.getString('email');
    final role = prefs.getString('role');
    final approved = prefs.getBool('approved');
    final active = prefs.getBool('active');

    if (uid == null ||
        name == null ||
        email == null ||
        role == null ||
        approved == null ||
        active == null) {
      await _clearPrefs();
      _user = null;
      notifyListeners();
      return;
    }

    _user = UserModel(
      uid: uid,
      name: name,
      email: email,
      role: role,
      approved: approved,
      active: active,
    );

    notifyListeners();
  }

  Future<void> _clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

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
    if (_user == null) return;

    if (role == 'Owner') {
      Navigator.pushReplacementNamed(context, AppRoutes.ownerHome);
    } else if (role == 'Manager') {
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
          createdAt: DateTime.now(),
          items: const [],
        ),
      );
    }
  }
}
