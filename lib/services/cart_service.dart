import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_coffee_shop/models/cart_model.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveCartToFirestore(
    String cartId,
    String consumerName,
    Map<String, CartItem> items,
    double totalAmount,
  ) async {
    try {
      DocumentReference cartRef = _db.collection('carts').doc(cartId);

      //Save Cart Metadata
      await cartRef.set({
        'consumerName': consumerName.isNotEmpty ? consumerName : cartId,
        'totalAmount': totalAmount,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      CollectionReference itemsRef = cartRef.collection('items');

      // Save cart items
      for (var item in items.values) {
        await itemsRef.doc(item.productId).set(item.toMap());
      }
    } catch (e) {
      throw Exception("Failed to seve cart");
    }
  }
}
