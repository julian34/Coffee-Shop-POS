import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/models/payment_model.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';
import 'package:pos_coffee_shop/services/payment_service.dart';
import 'package:provider/provider.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentService _paymentService = PaymentService();

  String _customerName = '';
  String get customerName => _customerName;

  Future<void> makePayment(Payment payment) async {
    await _paymentService.processPayment(payment);
    notifyListeners();
  }

  Future<void> fetchCustomerName(String orderId) async {
    try {
      _customerName =
          await _paymentService.getCustomerName(orderId) ?? 'unknown';

      notifyListeners();
    } catch (e) {
      print('Error fetching order: $e');
    }
  }

  // Clear customer name (optional for state management)
  void clearCustomerName() {
    _customerName = '';
    notifyListeners();
  }
}
