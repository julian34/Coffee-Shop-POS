import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_coffee_shop/models/payment_model.dart';

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> processPayment(Payment payment) async {
    //store payment record
    await _firestore.collection('payments').add(payment.toMap());
    //update Orders table to mark as paid and set paymMethod
    await _firestore.collection('orders').doc(payment.orderId).update({
      'paid': true,
      'paymentMode': payment.paymentMethod,
    });
  }

  Future<String?> getCustomerName(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        return doc.data()?['customerName'];
      }
    } catch (e) {
      print('Error fetching order: $e');
    }
    return null;
  }
}
