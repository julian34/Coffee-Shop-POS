import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Import the AuthService

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService(); // Use AuthService
  User? _user;
  String? _errorMessage;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _authService.authInstance.authStateChanges().listen(
      (User? user) {
        _user = user;
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
      _user = await _authService.signInWithEmail(email, password);
      notifyListeners();
      return null; // Success, no error
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "An unknown error occurred.";
      notifyListeners();
      return _errorMessage;
    } catch (e) {
      _errorMessage = "Unexpected error: ${e.toString()}";
      notifyListeners();
      return _errorMessage;
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      _user = await _authService.signInWithGoogle();
      notifyListeners();
      return null; // Success, no error
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message ?? "An unknown error occurred.";
      notifyListeners();
      return _errorMessage;
    } catch (e) {
      _errorMessage = "Unexpected error: ${e.toString()}";
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
}
