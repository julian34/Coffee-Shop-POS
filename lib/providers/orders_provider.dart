import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_coffee_shop/models/order_model.dart';

class OrdersProvider extends ChangeNotifier {
  final List<OrderList> _orders = [];
  List<OrderList> get orders => _orders;

  Future<void> fetchOrders() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('orders')
              .orderBy('timestamp', descending: true)
              .get();
      _orders.clear();
      _orders.addAll(
        querySnapshot.docs.map((doc) => OrderList.fromFirestore(doc)),
      );
      notifyListeners();
    } catch (e) {
      print("❌ Error fetching orders: $e");
    }
  }
}
