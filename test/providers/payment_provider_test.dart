import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pos_coffee_shop/models/payment_model.dart';
import 'package:pos_coffee_shop/providers/payment_provider.dart';
import 'package:pos_coffee_shop/services/order_service.dart';
import 'package:pos_coffee_shop/services/payment_service.dart';

import 'payment_provider_test.mocks.dart';

@GenerateMocks([PaymentService, OrderService])
void main() {
  group('PaymentProvider', () {
    late MockPaymentService mockPaymentService;
    late MockOrderService mockOrderService;
    late PaymentProvider provider;

    final tPayment = Payment(
      orderId: 'order-001',
      totalAmount: 75000,
      receivedAmount: 100000,
      changeAmount: 25000,
      paymentMethod: 'Cash',
      createdAt: DateTime(2024, 6, 1),
    );

    setUp(() {
      mockPaymentService = MockPaymentService();
      mockOrderService = MockOrderService();
      provider = PaymentProvider.forTest(
        paymentService: mockPaymentService,
        orderService: mockOrderService,
      );
    });

    // ── makePayment ───────────────────────────────────────────────────────

    test(
      'makePayment() memanggil processPayment pada PaymentService',
      () async {
        when(
          mockPaymentService.processPayment(tPayment),
        ).thenAnswer((_) async {});

        await provider.makePayment(tPayment);

        verify(mockPaymentService.processPayment(tPayment)).called(1);
      },
    );

    test('makePayment() memanggil notifyListeners setelah sukses', () async {
      when(
        mockPaymentService.processPayment(tPayment),
      ).thenAnswer((_) async {});

      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      await provider.makePayment(tPayment);

      expect(notifyCount, greaterThan(0));
    });

    // ── fetchCustomerName ─────────────────────────────────────────────────

    test('fetchCustomerName() memperbarui customerName dari service', () async {
      when(
        mockPaymentService.getCustomerName('order-001'),
      ).thenAnswer((_) async => 'Rudi Hartono');

      await provider.fetchCustomerName('order-001');

      expect(provider.customerName, 'Rudi Hartono');
    });

    test(
      'fetchCustomerName() menggunakan "unknown" saat service mengembalikan null',
      () async {
        when(
          mockPaymentService.getCustomerName('order-404'),
        ).thenAnswer((_) async => null);

        await provider.fetchCustomerName('order-404');

        expect(provider.customerName, 'unknown');
      },
    );

    test('fetchCustomerName() memanggil notifyListeners', () async {
      when(
        mockPaymentService.getCustomerName(any),
      ).thenAnswer((_) async => 'Test Customer');

      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      await provider.fetchCustomerName('order-001');

      expect(notifyCount, greaterThan(0));
    });

    // ── clearCustomerName ─────────────────────────────────────────────────

    test('clearCustomerName() mengosongkan customerName', () async {
      when(
        mockPaymentService.getCustomerName(any),
      ).thenAnswer((_) async => 'Nama Pelanggan');
      await provider.fetchCustomerName('order-001');

      provider.clearCustomerName();

      expect(provider.customerName, '');
    });

    test('clearCustomerName() memanggil notifyListeners', () {
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      provider.clearCustomerName();

      expect(notifyCount, greaterThan(0));
    });

    // ── fetchItemOrder ────────────────────────────────────────────────────

    test('fetchItemOrder() mengembalikan items dari OrderService', () async {
      final tItems = [
        {'name': 'Kopi Susu', 'quantity': 2, 'price': 25000},
      ];
      when(
        mockOrderService.getItemsOrder('order-001'),
      ).thenAnswer((_) async => tItems);

      final result = await provider.fetchItemOrder('order-001');

      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result.first['name'], 'Kopi Susu');
    });

    test(
      'fetchItemOrder() mengembalikan null saat service melempar exception',
      () async {
        when(
          mockOrderService.getItemsOrder(any),
        ).thenThrow(Exception('Firestore error'));

        final result = await provider.fetchItemOrder('order-err');

        expect(result, isNull);
      },
    );
  });
}
