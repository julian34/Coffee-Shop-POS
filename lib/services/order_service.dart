import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_coffee_shop/models/order_model.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<OrderList>> getOrders() {
    return _db
        .collection('orders')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => OrderList.fromMap(doc.data()))
                  .toList(),
        );
  }
}
