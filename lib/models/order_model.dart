// import 'package:cloud_firestore/cloud_firestore.dart';

class OrderList {
  final String idOrder;
  final String customerName;
  final double totalAmount;
  final bool isPaid;
  final String paymentMode;
  final String status; // "Pending" or "Checkout"
  final DateTime createdAt;

  OrderList({
    required this.idOrder,
    required this.customerName,
    required this.totalAmount,
    required this.isPaid,
    required this.paymentMode,
    required this.status,
    required this.createdAt,
  });

  factory OrderList.fromMap(Map<String, dynamic> map) {
    return OrderList(
      idOrder: map['id'] ?? '',
      customerName: map['customerName'] ?? 'Unknown',
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      isPaid: map['isPaid'] ?? false,
      paymentMode: map['paymentMode'] ?? 'Unknown',
      status: map['status'] ?? 'Pending',
      createdAt: (map['createdAt']).toDate(),
    );
  }
}
