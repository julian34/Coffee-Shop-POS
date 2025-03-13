import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String orderId;
  final double totalAmount;
  final double receivedAmount;
  final double changeAmount;
  final String paymentMethod; // 'cash' or 'qris'
  final DateTime createdAt;

  Payment({
    required this.orderId,
    required this.totalAmount,
    required this.receivedAmount,
    required this.changeAmount,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      orderId: map['order'] ?? '',
      totalAmount: (map['totalamount'] ?? 0.0).toDouble(),
      receivedAmount: (map['receivedAmount'] ?? 0.0).toDouble(),
      changeAmount: (map[''] ?? 0.0).toDouble(),
      paymentMethod: map['paymentMethod'] ?? 'Cash',
      createdAt: _parseDate(map['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'totalAmount': totalAmount,
      'receivedAmount': receivedAmount,
      'changeAmount': changeAmount,
      'paymentMethod': paymentMethod,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static DateTime? _parseDate(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    }
    return null;
  }
}
