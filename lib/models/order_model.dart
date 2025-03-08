import 'package:cloud_firestore/cloud_firestore.dart';

class OrderList {
  final String cartId;
  final String customerName;
  final double totalAmount;
  final bool isPaid;
  final String paymentMode;
  final String status; // "Pending" or "Checkout"
  final DateTime? createdAt;

  OrderList({
    required this.cartId,
    required this.customerName,
    required this.totalAmount,
    required this.isPaid,
    required this.paymentMode,
    required this.status,
    this.createdAt,
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
    );
  }

  static DateTime? _parseDate(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    }
  }
}
