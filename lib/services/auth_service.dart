import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Getter to access Firebase Auth instance
  FirebaseAuth get authInstance => _auth;

  // Sign in with Email & Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        bool isApproved = await _isUserApproved(user.uid);
        if (isApproved) {
          return user;
        } else {
          await _auth.signOut();
          throw FirebaseAuthException(
            code: "not-approved",
            message: "Access denied. Awaiting Manager/Owner approval.",
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: _getAuthErrorMessage(e.code),
      );
    }
    return null;
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      UserCredential result = await _auth.signInWithProvider(googleProvider);
      User? user = result.user;

      if (user != null) {
        bool isApproved = await _isUserApproved(user.uid);
        if (isApproved) {
          return user;
        } else {
          await _auth.signOut();
          throw FirebaseAuthException(
            code: "not-approved",
            message: "Access denied. Awaiting Manager/Owner approval.",
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: _getAuthErrorMessage(e.code),
      );
    }
    return null;
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Check if user is approved in Firestore
  Future<bool> _isUserApproved(String uid) async {
    DocumentSnapshot userDoc = await _db.collection("users").doc(uid).get();
    return userDoc.exists && (userDoc["approved"] == true);
  }

  // Map Firebase errors to user-friendly messages
  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Try again.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password is too weak. Choose a stronger one.';
      case 'not-approved':
        return 'Access denied. Awaiting Manager/Owner approval.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
