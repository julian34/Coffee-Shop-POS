import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_coffee_shop/models/cart_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveCart(
    String cartId,
    String consumerName,
    List<CartItem> items,
    double totalAmount,
  ) async {
    try {
      if (items.isEmpty) {
        print("Cart is empty, not saving.");
        return;
      }
      final cartData = {
        'cartId': cartId,
        'consumerName': consumerName.isEmpty ? cartId : consumerName,
        'items': items.map((item) => item.toMap()).toList(),
        'diskon': 0,
        'tax': 0,
        'totalAmount': totalAmount,
        'timestamp': FieldValue.serverTimestamp(),
      };
      await _firestore.collection('orders').doc(cartId).set(cartData);
    } catch (e) {
      print("Error saving cart to Firebase: $e");
    }
  }
}
