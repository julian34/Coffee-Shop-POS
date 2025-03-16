import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_coffee_shop/models/order_model.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<OrderList>> getOrders() {
    return _db
        .collection('orders')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => OrderList.fromMap(doc.data()))
                  .toList(),
        );
  }

  Future<List<Map<String, dynamic>>?> getItemsOrder(String orderId) async {
    try {
      final doc = await _db.collection('orders').doc(orderId).get();
      if (doc.exists) {
        print('service ${doc.data()?['items']}');
        return List<Map<String, dynamic>>.from(doc.data()?['items'] ?? []);
      }
    } catch (e) {
      print('Error fetching order: $e');
    }
    return null;
  }
}
