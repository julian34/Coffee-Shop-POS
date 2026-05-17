import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class AuthService {
  static const String _usersCollection = 'users';

  static const String _emailPasswordRequiredMessage =
      'Email and password are required.';
  static const String _userNotFoundMessage = 'User profile not found.';
  static const String _awaitingApprovalMessage =
      'Access denied. Awaiting Manager/Owner approval.';
  static const String _disabledAccountMessage =
      'Your account has been disabled. Contact support.';
  static const String _authenticationFailedMessage = 'Authentication failed.';
  static const String _googleSignInFailedMessage = 'Google sign-in failed.';
  static const String _registrationFailedMessage = 'Registration failed.';
  static const String _updateUserStatusFailedMessage =
      'Failed to update user status.';

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  AuthService({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _auth = firebaseAuth ?? FirebaseAuth.instance,
      _db = firestore ?? FirebaseFirestore.instance;

  FirebaseAuth get authInstance => _auth;

  Future<UserModel?> getUserData(String uid) async {
    if (uid.trim().isEmpty) return null;

    final DocumentSnapshot<Map<String, dynamic>> document =
        await _db.collection(_usersCollection).doc(uid).get();

    if (!document.exists || document.data() == null) return null;

    return UserModel.fromFirestore(document);
  }

  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      _validateEmailAndPassword(email, password);

      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      return _getValidatedUserFromCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthException(e));
    } on Exception {
      rethrow;
    } catch (_) {
      throw Exception(_authenticationFailedMessage);
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      final UserCredential credential = await _signInWithGoogleProvider();

      return _getValidatedUserFromCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthException(e));
    } on Exception {
      rethrow;
    } catch (_) {
      throw Exception(_googleSignInFailedMessage);
    }
  }

  Future<void> registerUser(UserModel user, String password) async {
    try {
      _validateEmailAndPassword(user.email, password);

      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: user.email.trim(),
        password: password,
      );

      final User? firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw Exception(_registrationFailedMessage);
      }

      final Map<String, dynamic> userData = user.toMap();
      userData['uid'] = firebaseUser.uid;

      await _db.collection(_usersCollection).doc(firebaseUser.uid).set(userData);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseAuthException(e));
    } on Exception {
      rethrow;
    } catch (_) {
      throw Exception(_registrationFailedMessage);
    }
  }

  Future<void> updateUserStatus(String uid, bool activeStatus) async {
    try {
      if (uid.trim().isEmpty) {
        throw Exception('User id cannot be empty.');
      }

      await _db.collection(_usersCollection).doc(uid).update({
        'active': activeStatus,
      });
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? _updateUserStatusFailedMessage);
    } on Exception {
      rethrow;
    } catch (_) {
      throw Exception(_updateUserStatusFailedMessage);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();

    if (!kIsWeb) {
      await GoogleSignIn.instance.signOut();
    }
  }

  Future<UserCredential> _signInWithGoogleProvider() async {
    if (kIsWeb) {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      return _auth.signInWithPopup(googleProvider);
    }

    final GoogleSignInAccount googleUser =
        await GoogleSignIn.instance.authenticate();
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    if (googleAuth.idToken == null) {
      throw Exception(_googleSignInFailedMessage);
    }

    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return _auth.signInWithCredential(credential);
  }

  Future<UserModel?> _getValidatedUserFromCredential(
    UserCredential credential,
  ) async {
    final User? firebaseUser = credential.user;

    if (firebaseUser == null) return null;

    final UserModel? user = await getUserData(firebaseUser.uid);

    if (user == null) {
      await signOut();
      throw Exception(_userNotFoundMessage);
    }

    await _ensureUserCanAccess(user);

    return user;
  }

  Future<void> _ensureUserCanAccess(UserModel user) async {
    if (!user.approved) {
      await signOut();
      throw Exception(_awaitingApprovalMessage);
    }

    if (!user.active) {
      await signOut();
      throw Exception(_disabledAccountMessage);
    }
  }

  void _validateEmailAndPassword(String email, String password) {
    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception(_emailPasswordRequiredMessage);
    }
  }

  String _mapFirebaseAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'Invalid email format.';
      case 'user-disabled':
        return _disabledAccountMessage;
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'Email is already registered.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return exception.message ?? _authenticationFailedMessage;
    }
  }
}
