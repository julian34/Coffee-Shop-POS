import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/models/payment_model.dart';
import 'package:pos_coffee_shop/services/order_service.dart';
import 'package:pos_coffee_shop/services/payment_service.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentService _paymentService = PaymentService();
  final OrderService _orderService = OrderService();

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

  Future<List<Map<String, dynamic>>?> fetchItemOrder(String orderId) async {
    try {
      return await _orderService.getItemsOrder(orderId);
    } catch (e) {
      print("Error fetching items: $e");
      return null;
    }
  }

  // Clear customer name (optional for state management)
  void clearCustomerName() {
    _customerName = '';
    notifyListeners();
  }
}
