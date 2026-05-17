import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_coffee_shop/models/cart_model.dart';

class CartService {
  final FirebaseFirestore _firestore;

  CartService([FirebaseFirestore? firestore])
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveCart(
    String cartId,
    String customerName,
    List<CartItem> items,
    double totalAmount,
    bool paid,
    String paymentMode,
  ) async {
    try {
      if (items.isEmpty) {
        print("Cart is empty, not saving.");
        return;
      }
      final cartData = {
        'cartId': cartId,
        'customerName': customerName.isEmpty ? cartId : customerName,
        'items': items.map((item) => item.toMap()).toList(),
        'diskon': 0,
        'tax': 0,
        'totalAmount': totalAmount,
        'paid': paid,
        'paymentMode': paymentMode.isEmpty ? '-' : paymentMode,
        'timestamp': FieldValue.serverTimestamp(),
      };
      await _firestore.collection('orders').doc(cartId).set(cartData);
    } catch (e) {
      print("Error saving cart to Firebase: $e");
    }
  }
}
