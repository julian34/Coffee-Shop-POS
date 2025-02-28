import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role; // "Owner", "Manager", "Cashier"
  final bool approved; // Approval by admin
  final bool active; // true = active, false = disabled

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.approved,
    required this.active,
  });

  // Convert Firestore document to UserModel
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'Cashier',
      approved: data['approved'] ?? false,
      active: data['active'] ?? true, // Default to active
    );
  }

  // Convert UserModel to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'approved': approved,
      'active': active,
    };
  }
}
