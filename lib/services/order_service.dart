import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_coffee_shop/models/order_model.dart';

class OrderService {
  static Future<List<OrderList>> getOrders() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      return snapshot.docs.map((doc) => OrderList.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }
}
