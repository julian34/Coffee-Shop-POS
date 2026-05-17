import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_coffee_shop/models/order_model.dart';

void main() {
  group('OrderList', () {
    // ── fromMap ───────────────────────────────────────────────────────────

    test('fromMap() membuat OrderList dengan nilai yang benar', () {
      final tDate = DateTime(2024, 6, 15, 10, 30);
      final map = {
        'cartId': 'cart-abc',
        'customerName': 'Budi Santoso',
        'totalAmount': 75000,
        'isPaid': true,
        'paid': true,
        'paymentMode': 'Cash',
        'status': 'Paid',
        'createdAt': tDate,
        'items': [],
      };

      final result = OrderList.fromMap(map);

      expect(result.cartId, 'cart-abc');
      expect(result.customerName, 'Budi Santoso');
      expect(result.totalAmount, 75000.0);
      expect(result.isPaid, true);
      expect(result.paid, true);
      expect(result.paymentMode, 'Cash');
      expect(result.status, 'Paid');
    });

    test('fromMap() menggunakan nilai default saat field kosong/null', () {
      final result = OrderList.fromMap({});

      expect(result.cartId, '');
      expect(result.customerName, 'Unknown');
      expect(result.totalAmount, 0.0);
      expect(result.isPaid, false);
      expect(result.paid, false);
      expect(result.paymentMode, 'Cash');
      expect(result.status, 'Pending');
      expect(result.items, isEmpty);
    });

    test('fromMap() parsing createdAt dari Timestamp Firestore', () {
      final tDate = DateTime(2024, 6, 15, 10, 30);
      final map = {
        'cartId': 'cart-ts',
        'createdAt': Timestamp.fromDate(tDate),
        'items': [],
      };

      final result = OrderList.fromMap(map);

      expect(result.createdAt.year, 2024);
      expect(result.createdAt.month, 6);
      expect(result.createdAt.day, 15);
    });

    test('fromMap() parsing createdAt dari DateTime langsung', () {
      final tDate = DateTime(2024, 3, 20);
      final map = {'cartId': 'cart-dt', 'createdAt': tDate, 'items': []};

      final result = OrderList.fromMap(map);

      expect(result.createdAt, tDate);
    });

    test('fromMap() parsing createdAt dari String ISO', () {
      final map = {
        'cartId': 'cart-str',
        'createdAt': '2024-01-10T08:00:00.000',
        'items': [],
      };

      final result = OrderList.fromMap(map);

      expect(result.createdAt.year, 2024);
      expect(result.createdAt.month, 1);
      expect(result.createdAt.day, 10);
    });

    test('fromMap() parsing items list menjadi List<CartItem>', () {
      final map = {
        'cartId': 'cart-items',
        'items': [
          {
            'productId': 'p1',
            'name': 'Espresso',
            'price': 20000,
            'label': 'Hot',
            'selectedPrice': {'label': 'Hot', 'amount': 20000},
            'quantity': 1,
            'image': '',
          },
        ],
      };

      final result = OrderList.fromMap(map);

      expect(result.items.length, 1);
      expect(result.items.first.productId, 'p1');
      expect(result.items.first.name, 'Espresso');
    });

    test('fromMap() mengabaikan items yang bukan Map', () {
      final map = {
        'cartId': 'cart-bad',
        'items': ['string', 123, null],
      };

      final result = OrderList.fromMap(map);

      expect(result.items, isEmpty);
    });

    // ── empty ─────────────────────────────────────────────────────────────

    test('empty() menghasilkan OrderList dengan nilai default', () {
      final result = OrderList.empty();

      expect(result.cartId, '');
      expect(result.customerName, 'Guest');
      expect(result.totalAmount, 0.0);
      expect(result.isPaid, false);
      expect(result.paid, false);
      expect(result.paymentMode, 'Cash');
      expect(result.status, 'Pending');
      expect(result.items, isEmpty);
    });

    // ── toMap ─────────────────────────────────────────────────────────────

    test('toMap() mengembalikan semua field', () {
      final order = OrderList(
        cartId: 'c-001',
        customerName: 'Ani',
        totalAmount: 50000,
        isPaid: false,
        paid: false,
        paymentMode: 'QRIS',
        status: 'Pending',
        createdAt: DateTime(2024, 5, 1),
        items: [],
      );

      final map = order.toMap();

      expect(map['cartId'], 'c-001');
      expect(map['customerName'], 'Ani');
      expect(map['totalAmount'], 50000.0);
      expect(map['paymentMode'], 'QRIS');
      expect(map['status'], 'Pending');
      expect(map['items'], isEmpty);
      expect(map['createdAt'], isA<Timestamp>());
    });
  });
}
