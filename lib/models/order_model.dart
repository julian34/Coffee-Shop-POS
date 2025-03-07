import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_model.dart';

class OrderList {
  final String cartId;
  final String consumerName;
  final List<CartItem> items;
  final double totalAmount;
  final bool paid;
  final String paymentMode;
  final DateTime timestamp;

  OrderList({
    required this.cartId,
    required this.consumerName,
    required this.items,
    required this.totalAmount,
    required this.paid,
    required this.paymentMode,
    required this.timestamp,
  });

  factory OrderList.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return OrderList(
      cartId: data['cartId'],
      consumerName: data['consumerName'],
      items:
          (data['items'] as List)
              .map((item) => CartItem.fromMap(item))
              .toList(),
      totalAmount: data['totalAmount'].toDouble(),
      paid: data['paid'] ?? false,
      paymentMode: data['paymentMode'] ?? "Unknown",
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
