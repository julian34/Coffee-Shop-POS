import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/routes.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  static const String _keyUid = 'uid';
  static const String _keyName = 'name';
  static const String _keyEmail = 'email';
  static const String _keyRole = 'role';
  static const String _keyApproved = 'approved';
  static const String _keyActive = 'active';

  static const String _roleOwner = 'Owner';
  static const String _roleManager = 'Manager';
  static const String _roleCashier = 'Cashier';

  StreamSubscription<User?>? _authStateSubscription;

  UserModel? _user;
  String? _errorMessage;
  bool _isLoading = false;

  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  bool get isAuthenticated => _user != null && _user!.active;

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadUserFromPrefs();
    _listenToAuthState();
  }

  void _listenToAuthState() {
    _authStateSubscription = _authService.authInstance
        .authStateChanges()
        .listen(
          _handleAuthStateChanged,
          onError: (error) {
            _setError('Auth state error: ${error.toString()}');
          },
        );
  }

  Future<void> _handleAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      await _clearUserSession();
      _user = null;
      notifyListeners();
      return;
    }

    final UserModel? userData = await _authService.getUserData(
      firebaseUser.uid,
    );

    if (userData == null) {
      await _authService.signOut();
      await _clearUserSession();
      _user = null;
      _setError('User data not found.');
      return;
    }

    if (!userData.active) {
      await _authService.signOut();
      await _clearUserSession();
      _user = null;
      _setError('Your account is disabled.');
      return;
    }

    _user = userData;
    _errorMessage = null;
    await _saveUserToPrefs(userData);
    notifyListeners();
  }

  Future<String?> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final UserModel? signedInUser = await _authService.signInWithEmail(
        email,
        password,
      );

      if (signedInUser == null) {
        await _clearUserSession();
        _user = null;
        return _setErrorAndReturn('User profile not found.');
      }

      if (!signedInUser.active) {
        await _authService.signOut();
        await _clearUserSession();
        _user = null;
        return _setErrorAndReturn('Your account is disabled.');
      }

      _user = signedInUser;
      await _saveUserToPrefs(signedInUser);

      _errorMessage = null;
      return null;
    } on Exception catch (e) {
      return _setErrorAndReturn(_formatErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);

    try {
      await _authService.signOut();
      await _clearUserSession();

      _user = null;
      _errorMessage = null;
    } on Exception catch (e) {
      _errorMessage = _formatErrorMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveUserRole(String role) async {
    if (role.trim().isEmpty) {
      _setError('User role cannot be empty.');
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRole, role);
  }

  Future<void> updateUserStatus(String uid, bool activeStatus) async {
    _setLoading(true);

    try {
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

        await _saveUserToPrefs(_user!);
      }

      _errorMessage = null;
    } on Exception catch (e) {
      _errorMessage = _formatErrorMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  void navigateBasedOnRole(BuildContext context, String role) {
    if (!isAuthenticated) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }

    Navigator.pushReplacementNamed(context, _getHomeRouteByRole(role));
  }

  String _getHomeRouteByRole(String role) {
    switch (role) {
      case _roleOwner:
        return AppRoutes.ownerHome;
      case _roleManager:
        return AppRoutes.managerHome;
      case _roleCashier:
      default:
        return AppRoutes.cashierHome;
    }
  }

  Future<void> _saveUserToPrefs(UserModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyUid, user.uid);
    await prefs.setString(_keyName, user.name);
    await prefs.setString(_keyEmail, user.email);
    await prefs.setString(_keyRole, user.role);
    await prefs.setBool(_keyApproved, user.approved);
    await prefs.setBool(_keyActive, user.active);
  }

  Future<void> _loadUserFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? uid = prefs.getString(_keyUid);
    final String? name = prefs.getString(_keyName);
    final String? email = prefs.getString(_keyEmail);
    final String? role = prefs.getString(_keyRole);
    final bool? approved = prefs.getBool(_keyApproved);
    final bool? active = prefs.getBool(_keyActive);

    if (uid == null ||
        name == null ||
        email == null ||
        role == null ||
        approved == null ||
        active == null) {
      await _clearUserSession();
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

  Future<void> _clearUserSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(_keyUid);
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyRole);
    await prefs.remove(_keyApproved);
    await prefs.remove(_keyActive);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  String _setErrorAndReturn(String message) {
    _errorMessage = message;
    notifyListeners();
    return message;
  }

  String _formatErrorMessage(Exception exception) {
    return exception.toString().replaceFirst('Exception: ', '');
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}
