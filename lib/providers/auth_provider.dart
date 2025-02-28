import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    _authService.authInstance.authStateChanges().listen(
      (User? firebaseUser) async {
        if (firebaseUser != null) {
          _user = await _authService.getUserData(firebaseUser.uid);
          if (_user != null && !_user!.active) {
            await _authService.signOut();
            _user = null;
            _errorMessage = "Your account is disabled.";
          }
        } else {
          _user = null;
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
      notifyListeners();
      print(
        "1. User signed in: ${_user?.name}, Role: ${_user?.role}",
      ); // Debugging
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
    notifyListeners();
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
    if (role == "Owner") {
      Navigator.pushReplacementNamed(context, AppRoutes.ownerHome);
    } else if (role == "Manager") {
      Navigator.pushReplacementNamed(context, AppRoutes.managerHome);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.cashierHome);
    }
  }
}
