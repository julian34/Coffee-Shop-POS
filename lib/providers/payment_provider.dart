import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/models/payment_model.dart';
import 'package:pos_coffee_shop/services/payment_service.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentService _paymentService = PaymentService();

  Future<void> makePayment(Payment payment) async {
    await _paymentService.processPayment(payment);
    notifyListeners();
  }
}
