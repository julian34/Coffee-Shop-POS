import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_coffee_shop/models/payment_model.dart';
import 'package:pos_coffee_shop/services/payment_service.dart';

void main() {
  group('PaymentService', () {
    late FakeFirebaseFirestore fakeFirestore;
    late PaymentService service;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      service = PaymentService(fakeFirestore);
    });

    // ── processPayment ────────────────────────────────────────────────────

    test('processPayment() menulis dokumen ke koleksi payments', () async {
      final payment = Payment(
        orderId: 'order-001',
        totalAmount: 50000,
        receivedAmount: 50000,
        changeAmount: 0,
        paymentMethod: 'Cash',
        createdAt: DateTime(2024, 6, 1),
      );

      await service.processPayment(payment);

      final paymentsSnap = await fakeFirestore.collection('payments').get();
      expect(paymentsSnap.docs.length, 1);
      expect(paymentsSnap.docs.first.data()['orderId'], 'order-001');
      expect(paymentsSnap.docs.first.data()['totalAmount'], 50000.0);
    });

    test(
      'processPayment() mengupdate field paid=true pada koleksi orders',
      () async {
        // Buat order terlebih dahulu
        await fakeFirestore.collection('orders').doc('order-001').set({
          'cartId': 'order-001',
          'customerName': 'Test',
          'paid': false,
          'paymentMode': 'Cash',
          'totalAmount': 50000,
          'items': [],
        });

        final payment = Payment(
          orderId: 'order-001',
          totalAmount: 50000,
          receivedAmount: 50000,
          changeAmount: 0,
          paymentMethod: 'QRIS',
          createdAt: DateTime(2024, 6, 1),
        );

        await service.processPayment(payment);

        final orderDoc =
            await fakeFirestore.collection('orders').doc('order-001').get();
        expect(orderDoc.data()?['paid'], true);
        expect(orderDoc.data()?['paymentMode'], 'QRIS');
      },
    );

    test('processPayment() menyimpan paymentMethod dengan benar', () async {
      final payment = Payment(
        orderId: 'order-qris',
        totalAmount: 30000,
        receivedAmount: 30000,
        changeAmount: 0,
        paymentMethod: 'QRIS',
        createdAt: DateTime(2024, 7, 1),
      );

      await service.processPayment(payment);

      final snap = await fakeFirestore.collection('payments').get();
      expect(snap.docs.first.data()['paymentMethod'], 'QRIS');
    });

    // ── getCustomerName ───────────────────────────────────────────────────

    test('getCustomerName() mengembalikan nama pelanggan yang benar', () async {
      await fakeFirestore.collection('orders').doc('order-abc').set({
        'customerName': 'Dewi Sartika',
        'totalAmount': 45000,
      });

      final name = await service.getCustomerName('order-abc');

      expect(name, 'Dewi Sartika');
    });

    test(
      'getCustomerName() mengembalikan null saat order tidak ditemukan',
      () async {
        final name = await service.getCustomerName('tidak-ada');

        expect(name, isNull);
      },
    );

    test(
      'getCustomerName() mengembalikan null saat field customerName tidak ada',
      () async {
        await fakeFirestore.collection('orders').doc('order-noncust').set({
          'totalAmount': 10000,
        });

        final name = await service.getCustomerName('order-noncust');

        expect(name, isNull);
      },
    );
  });
}
