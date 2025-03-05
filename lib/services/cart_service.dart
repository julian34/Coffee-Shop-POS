import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos_coffee_shop/models/cart_model.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final Uuid _uuid = Uuid();

  // Generate or Get Existing Cart ID
  Future<String> getOrCreateCartId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartId = prefs.getString('cart_id');

    if (cartId == null) {
      cartId = _uuid.v4();
      await prefs.setString('cart_id', cartId);
      await _db.collection('carts').doc(cartId).set({
        'createdAt': FieldValue.serverTimestamp(),
        'consumerName': cartId, // Default to cart ID
      });
    }
    return cartId;
  }

  // Get Consumer Name
  Future<String> getConsumerName(String cartId) async {
    DocumentSnapshot doc = await _db.collection('carts').doc(cartId).get();
    return doc.exists ? (doc['consumerName'] ?? cartId) : cartId;
  }

  // Update Consumer Name
  Future<void> updateConsumerName(String cartId, String name) async {
    await _db.collection('carts').doc(cartId).update({'consumerName': name});
  }

  // Reference to cart collection
  Future<CollectionReference> _getCartCollection() async {
    String cartId = await getOrCreateCartId();
    return _db.collection('carts').doc(cartId).collection('cartItems');
  }

  // Fetch cart items as a stream
  Future<Stream<List<CartItem>>> getCartItems() async {
    CollectionReference cartCollection = await _getCartCollection();
    return cartCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) =>
                CartItem.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
    });
  }

  // Add item to cart
  Future<void> addToCart(String cartId, CartItem item) async {
    // try {
    //   DocumentReference cartRef = _db.collection('carts').doc(cartId);
    //   await cartRef.set({
    //     'items': FieldValue.arrayUnion([item.toMap()]),
    //   }, SetOptions(merge: true));
    //   print("Debug: Added to Firestore - Cart: $cartId, Item: ${item.toMap()}");
    // } catch (e) {
    //   print("Error adding to Firestore: $e");
    // }
    print("service");
  }

  // Update item quantity in cart
  Future<void> updateQuantity(String itemId, int quantity) async {
    CollectionReference cartCollection = await _getCartCollection();
    if (quantity > 0) {
      await cartCollection.doc(itemId).update({'quantity': quantity});
    } else {
      await removeFromCart(itemId);
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String itemId) async {
    CollectionReference cartCollection = await _getCartCollection();
    await cartCollection.doc(itemId).delete();
  }

  // Clear entire cart
  Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartId = prefs.getString('cart_id');

    if (cartId != null) {
      CollectionReference cartCollection = await _getCartCollection();
      var snapshots = await cartCollection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
      await prefs.remove('cart_id');
    }
  }
}
