import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_coffee_shop/models/payment_model.dart';

void main() {
  group('Payment', () {
    // ── fromMap ───────────────────────────────────────────────────────────

    test('fromMap() membuat Payment dengan nilai yang benar', () {
      final tDate = DateTime(2024, 6, 15);
      final map = {
        'orderId': 'order-xyz',
        'totalAmount': 75000,
        'receivedAmount': 100000,
        'changeAmount': 25000,
        'paymentMethod': 'Cash',
        'createdAt': tDate,
      };

      final result = Payment.fromMap(map);

      expect(result.orderId, 'order-xyz');
      expect(result.totalAmount, 75000.0);
      expect(result.receivedAmount, 100000.0);
      expect(result.changeAmount, 25000.0);
      expect(result.paymentMethod, 'Cash');
    });

    test('fromMap() mengkonversi int ke double', () {
      final map = {
        'orderId': 'o-int',
        'totalAmount': 50000,
        'receivedAmount': 50000,
        'changeAmount': 0,
        'createdAt': DateTime.now(),
      };

      final result = Payment.fromMap(map);

      expect(result.totalAmount, isA<double>());
      expect(result.receivedAmount, isA<double>());
      expect(result.changeAmount, isA<double>());
    });

    test('fromMap() mengkonversi double literal ke double', () {
      final map = {
        'orderId': 'o-dbl',
        'totalAmount': 25000.5,
        'receivedAmount': 30000.0,
        'changeAmount': 4999.5,
        'createdAt': DateTime.now(),
      };

      final result = Payment.fromMap(map);

      expect(result.totalAmount, 25000.5);
      expect(result.changeAmount, 4999.5);
    });

    test('fromMap() menggunakan nilai default saat field null', () {
      final result = Payment.fromMap({});

      expect(result.orderId, '');
      expect(result.totalAmount, 0.0);
      expect(result.receivedAmount, 0.0);
      expect(result.changeAmount, 0.0);
      expect(result.paymentMethod, 'Cash');
    });

    test('fromMap() parsing createdAt dari Timestamp Firestore', () {
      final tDate = DateTime(2024, 4, 10, 9, 0);
      final map = {'orderId': 'o-ts', 'createdAt': Timestamp.fromDate(tDate)};

      final result = Payment.fromMap(map);

      expect(result.createdAt.year, 2024);
      expect(result.createdAt.month, 4);
    });

    test('fromMap() parsing createdAt dari String ISO', () {
      final map = {'orderId': 'o-str', 'createdAt': '2024-08-20T14:00:00.000'};

      final result = Payment.fromMap(map);

      expect(result.createdAt.year, 2024);
      expect(result.createdAt.month, 8);
      expect(result.createdAt.day, 20);
    });

    // ── toMap ─────────────────────────────────────────────────────────────

    test('toMap() mengembalikan semua field yang diperlukan', () {
      final payment = Payment(
        orderId: 'o-001',
        totalAmount: 45000,
        receivedAmount: 50000,
        changeAmount: 5000,
        paymentMethod: 'QRIS',
        createdAt: DateTime(2024, 7, 1),
      );

      final map = payment.toMap();

      expect(map['orderId'], 'o-001');
      expect(map['totalAmount'], 45000.0);
      expect(map['receivedAmount'], 50000.0);
      expect(map['changeAmount'], 5000.0);
      expect(map['paymentMethod'], 'QRIS');
      expect(map['createdAt'], isA<Timestamp>());
    });

    test('changeAmount dihitung benar: receivedAmount - totalAmount', () {
      const total = 60000.0;
      const received = 100000.0;
      const change = received - total;

      final payment = Payment(
        orderId: 'o-change',
        totalAmount: total,
        receivedAmount: received,
        changeAmount: change,
        paymentMethod: 'Cash',
        createdAt: DateTime.now(),
      );

      expect(payment.changeAmount, 40000.0);
    });
  });
}
