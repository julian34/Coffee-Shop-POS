import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirebaseAuth get authInstance => _auth;

  // Fetch user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    DocumentSnapshot doc = await _db.collection("users").doc(uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  // Sign in with Email & Password (Check Approval & Active Status)
  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = result.user;

      if (firebaseUser != null) {
        UserModel? user = await getUserData(firebaseUser.uid);

        if (user != null) {
          if (!user.approved) {
            await _auth.signOut();
            throw Exception("Access denied. Awaiting Manager/Owner approval.");
          } else if (!user.active) {
            await _auth.signOut();
            throw Exception("Your account has been disabled. Contact support.");
          }
          return user;
        }
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Authentication failed");
    }
    return null;
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      UserCredential result = await _auth.signInWithPopup(googleProvider);
      User? firebaseUser = result.user;

      if (firebaseUser != null) {
        UserModel? user = await getUserData(firebaseUser.uid);

        if (user != null) {
          if (!user.approved) {
            await _auth.signOut();
            throw Exception("Access denied. Awaiting Manager/Owner approval.");
          } else if (!user.active) {
            await _auth.signOut();
            throw Exception("Your account has been disabled. Contact support.");
          }
          return user;
        }
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Google sign-in failed");
    }
    return null;
  }

  // Register User with Default "Disabled" Status
  Future<void> registerUser(UserModel user, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );
      User? firebaseUser = result.user;

      if (firebaseUser != null) {
        await _db.collection("users").doc(firebaseUser.uid).set(user.toMap());
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Registration failed");
    }
  }

  // Disable/Enable User
  Future<void> updateUserStatus(String uid, bool activeStatus) async {
    await _db.collection("users").doc(uid).update({'active': activeStatus});
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
