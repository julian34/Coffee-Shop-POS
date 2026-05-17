import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthService {
  static const String _usersCollection = 'users';

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  AuthService({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _auth = firebaseAuth ?? FirebaseAuth.instance,
      _db = firestore ?? FirebaseFirestore.instance;

  FirebaseAuth get authInstance => _auth;

  Future<UserModel?> getUserData(String uid) async {
    final String cleanUid = uid.trim();

    if (cleanUid.isEmpty) {
      throw Exception('User ID cannot be empty.');
    }

    try {
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await _db.collection(_usersCollection).doc(cleanUid).get();

      if (!doc.exists) {
        return null;
      }

      return UserModel.fromFirestore(doc);
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? 'Failed to fetch user data.');
    } catch (e) {
      throw Exception('Failed to fetch user data.');
    }
  }

  Future<UserModel?> signInWithEmail(String email, String password) async {
    final String cleanEmail = email.trim();
    final String cleanPassword = password.trim();

    if (cleanEmail.isEmpty || cleanPassword.isEmpty) {
      throw Exception('Email and password are required.');
    }

    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: cleanPassword,
      );

      final User? firebaseUser = credential.user;

      if (firebaseUser == null) {
        return null;
      }

      final UserModel? user = await getUserData(firebaseUser.uid);

      if (user == null) {
        await signOut();
        return null;
      }

      await _validateUserAccess(user);

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Authentication failed.');
    } catch (e) {
      throw Exception(_formatExceptionMessage(e));
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();

      final UserCredential credential = await _auth.signInWithPopup(
        googleProvider,
      );

      final User? firebaseUser = credential.user;

      if (firebaseUser == null) {
        return null;
      }

      final UserModel? user = await getUserData(firebaseUser.uid);

      if (user == null) {
        await signOut();
        return null;
      }

      await _validateUserAccess(user);

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Google sign-in failed.');
    } catch (e) {
      throw Exception(_formatExceptionMessage(e));
    }
  }

  Future<void> registerUser(UserModel user, String password) async {
    final String cleanEmail = user.email.trim();
    final String cleanPassword = password.trim();

    if (cleanEmail.isEmpty || cleanPassword.isEmpty) {
      throw Exception('Email and password are required.');
    }

    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(
            email: cleanEmail,
            password: cleanPassword,
          );

      final User? firebaseUser = credential.user;

      if (firebaseUser == null) {
        throw Exception('Registration failed. User credential not found.');
      }

      await _db
          .collection(_usersCollection)
          .doc(firebaseUser.uid)
          .set(user.toMap());
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Registration failed.');
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? 'Failed to save user data.');
    } catch (e) {
      throw Exception(_formatExceptionMessage(e));
    }
  }

  Future<void> updateUserStatus(String uid, bool activeStatus) async {
    final String cleanUid = uid.trim();

    if (cleanUid.isEmpty) {
      throw Exception('User ID cannot be empty.');
    }

    try {
      await _db.collection(_usersCollection).doc(cleanUid).update({
        'active': activeStatus,
      });
    } on FirebaseException catch (e) {
      throw Exception(e.message ?? 'Failed to update user status.');
    } catch (e) {
      throw Exception('Failed to update user status.');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to sign out.');
    } catch (e) {
      throw Exception('Failed to sign out.');
    }
  }

  Future<void> _validateUserAccess(UserModel user) async {
    if (!user.approved) {
      await signOut();
      throw Exception('Access denied. Awaiting Manager/Owner approval.');
    }

    if (!user.active) {
      await signOut();
      throw Exception('Your account has been disabled. Contact support.');
    }
  }

  String _formatExceptionMessage(Object error) {
    final String message = error.toString();
    return message.replaceFirst('Exception: ', '');
  }
}
