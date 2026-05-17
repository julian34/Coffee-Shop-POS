import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_coffee_shop/services/order_service.dart';

void main() {
  group('OrderService', () {
    late FakeFirebaseFirestore fakeFirestore;
    late OrderService service;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      service = OrderService(fakeFirestore);
    });

    // ── getItemsOrder ─────────────────────────────────────────────────────

    test(
      'getItemsOrder() mengembalikan daftar items dari order yang ada',
      () async {
        await fakeFirestore.collection('orders').doc('order-001').set({
          'cartId': 'order-001',
          'customerName': 'Rina',
          'items': [
            {
              'productId': 'p1',
              'name': 'Cappuccino',
              'price': 28000,
              'quantity': 2,
              'label': 'Hot',
            },
            {
              'productId': 'p2',
              'name': 'Croissant',
              'price': 15000,
              'quantity': 1,
              'label': 'Regular',
            },
          ],
        });

        final items = await service.getItemsOrder('order-001');

        expect(items, isNotNull);
        expect(items!.length, 2);
        expect(items.first['name'], 'Cappuccino');
        expect(items.last['name'], 'Croissant');
      },
    );

    test(
      'getItemsOrder() mengembalikan list kosong saat items field kosong',
      () async {
        await fakeFirestore.collection('orders').doc('order-empty').set({
          'cartId': 'order-empty',
          'items': [],
        });

        final items = await service.getItemsOrder('order-empty');

        expect(items, isNotNull);
        expect(items, isEmpty);
      },
    );

    test(
      'getItemsOrder() mengembalikan null saat order tidak ditemukan',
      () async {
        final items = await service.getItemsOrder('tidak-ada');

        expect(items, isNull);
      },
    );

    test('getItemsOrder() mengembalikan items dengan data lengkap', () async {
      await fakeFirestore.collection('orders').doc('order-full').set({
        'cartId': 'order-full',
        'items': [
          {
            'productId': 'prod-abc',
            'name': 'Matcha Latte',
            'price': 32000,
            'quantity': 3,
            'label': 'Large',
            'image': 'assets/matcha.png',
          },
        ],
      });

      final items = await service.getItemsOrder('order-full');

      final item = items!.first;
      expect(item['productId'], 'prod-abc');
      expect(item['price'], 32000);
      expect(item['quantity'], 3);
      expect(item['label'], 'Large');
    });

    // ── getOrders stream ──────────────────────────────────────────────────

    test('getOrders() mengembalikan Stream yang tidak null', () {
      expect(service.getOrders(), isA<Stream>());
    });

    test('getOrders() memancarkan data dari Firestore', () async {
      await fakeFirestore.collection('orders').add({
        'cartId': 'o-stream',
        'customerName': 'Streaming User',
        'timestamp': Timestamp.now(),
      });

      final stream = service.getOrders();
      final result = await stream.first;

      expect(result, isNotEmpty);
    });
  });
}
