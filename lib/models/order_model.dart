import 'package:cloud_firestore/cloud_firestore.dart';

class OrderList {
  final String cartId;
  final String customerName;
  final double totalAmount;
  final bool isPaid;
  final String paymentMode;
  final String status; // "Pending" or "Checkout"
  final DateTime? createdAt;
  final List<Map<String, dynamic>> items;

  OrderList({
    required this.cartId,
    required this.customerName,
    required this.totalAmount,
    required this.isPaid,
    required this.paymentMode,
    required this.status,
    this.createdAt,
    required this.items,
  });

  factory OrderList.fromMap(Map<String, dynamic> map) {
    return OrderList(
      cartId: map['cartId'] ?? '',
      customerName: map['customerName'] ?? 'Unknown',
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      isPaid: map['isPaid'] ?? false,
      paymentMode: map['paymentMode'] ?? 'Unknown',
      status: map['status'] ?? 'Pending',
      createdAt: _parseDate(map['createdAt']),
      items:
          map['items'] != null && map['items'] is List
              ? List<Map<String, dynamic>>.from(map['items'])
              : [],
    );
  }

  static DateTime? _parseDate(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    }
  }
}
