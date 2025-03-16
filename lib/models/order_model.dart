import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_model.dart';

class OrderList {
  final String cartId;
  final String customerName;
  final double totalAmount;
  final bool isPaid;
  final String paymentMode;
  final String status; // "Pending" or "Checkout"
  final DateTime createdAt; // Ensure it's non-null
  final bool paid;
  final List<CartItem> items; // Convert items properly

  OrderList({
    required this.cartId,
    required this.customerName,
    required this.totalAmount,
    required this.isPaid,
    required this.paid,
    required this.paymentMode,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  // ✅ Convert Firestore Map -> OrderList Object
  factory OrderList.fromMap(Map<String, dynamic> map) {
    return OrderList(
      cartId: map['cartId'] ?? '',
      customerName: map['customerName'] ?? 'Unknown',
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      isPaid: map['isPaid'] ?? false,
      paid: map['paid'] ?? false,
      paymentMode: map['paymentMode'] ?? 'Cash',
      status: map['status'] ?? 'Pending',
      createdAt:
          _parseDate(map['createdAt']) ??
          DateTime.now(), // Use current time if missing
      items:
          (map['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromMap(item))
              .toList() ??
          [],
    );
  }

  // ✅ Convert OrderList Object -> Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'cartId': cartId,
      'customerName': customerName,
      'totalAmount': totalAmount,
      'isPaid': isPaid,
      'paid': paid,
      'paymentMode': paymentMode,
      'status': status,
      'createdAt': Timestamp.fromDate(
        createdAt,
      ), // Convert to Firestore Timestamp
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  // 🔹 Helper to parse Firestore Timestamp
  static DateTime? _parseDate(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    }
    return null;
  }

  factory OrderList.empty() {
    return OrderList(
      cartId: '',
      customerName: 'Guest',
      totalAmount: 0.0,
      isPaid: false,
      paid: false,
      paymentMode: 'Cash',
      status: 'Pending',
      createdAt: DateTime.now(),
      items: [],
    );
  }
}
