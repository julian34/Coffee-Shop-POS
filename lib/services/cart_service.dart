import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_model.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId = "sampleUserId"; // Replace with auth userId

  CollectionReference get _cartCollection =>
      _db.collection('carts').doc(userId).collection('cartItems');

  Stream<List<CartItem>> getCartItems() {
    return _cartCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) =>
                CartItem.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
    });
  }

  Future<void> addToCart(CartItem item) async {
    DocumentReference docRef = _cartCollection.doc(item.id);

    return _db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(docRef);
      if (snapshot.exists) {
        int newQuantity = snapshot['quantity'] + 1;
        transaction.update(docRef, {'quantity': newQuantity});
      } else {
        transaction.set(docRef, item.toMap());
      }
    });
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity > 0) {
      await _cartCollection.doc(itemId).update({'quantity': quantity});
    } else {
      await removeFromCart(itemId);
    }
  }

  Future<void> removeFromCart(String itemId) async {
    await _cartCollection.doc(itemId).delete();
  }

  Future<void> clearCart() async {
    var snapshots = await _cartCollection.get();
    for (var doc in snapshots.docs) {
      doc.reference.delete();
    }
  }
}
