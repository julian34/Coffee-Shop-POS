import 'package:flutter_test/flutter_test.dart';
import 'package:pos_coffee_shop/models/order_model.dart';
import 'package:pos_coffee_shop/providers/orders_provider.dart';

// OrderProvider memanggil fetchOrders() + loadStatusFilter() di constructor
// yang membutuhkan Firebase dan SharedPreferences. Untuk mengisolasi logika
// applyFilters(), kita buat subclass minimal yang men-skip constructor calls.
class _TestableOrderProvider extends OrderProvider {
  _TestableOrderProvider() : super.forTest();

  void seedOrders(List<OrderList> orders) {
    // ignore: invalid_use_of_protected_member
    setOrdersForTest(orders);
  }
}

void main() {
  group('OrderProvider — applyFilters()', () {
    late _TestableOrderProvider provider;

    final pendingOrder = OrderList(
      cartId: 'c-001',
      customerName: 'Andi Cahyono',
      totalAmount: 50000,
      isPaid: false,
      paid: false,
      paymentMode: 'Cash',
      status: 'Pending',
      createdAt: DateTime.now(),
      items: [],
    );

    final paidOrder = OrderList(
      cartId: 'c-002',
      customerName: 'Budi Laksono',
      totalAmount: 75000,
      isPaid: true,
      paid: true,
      paymentMode: 'QRIS',
      status: 'Paid',
      createdAt: DateTime.now(),
      items: [],
    );

    final anotherPending = OrderList(
      cartId: 'c-003',
      customerName: 'Citra Dewi',
      totalAmount: 30000,
      isPaid: false,
      paid: false,
      paymentMode: 'Cash',
      status: 'Pending',
      createdAt: DateTime.now(),
      items: [],
    );

    setUp(() {
      provider = _TestableOrderProvider();
      provider.seedOrders([pendingOrder, paidOrder, anotherPending]);
    });

    // ── Status filter ─────────────────────────────────────────────────────

    test('filter "Pending" hanya menampilkan order yang belum dibayar', () {
      provider.updateStatusFilter('Pending');

      expect(provider.filteredOrders.length, 2);
      expect(provider.filteredOrders.every((o) => !o.paid && !o.isPaid), true);
    });

    test('filter "Paid" hanya menampilkan order yang sudah dibayar', () {
      provider.updateStatusFilter('Paid');

      expect(provider.filteredOrders.length, 1);
      expect(provider.filteredOrders.first.cartId, 'c-002');
    });

    test('filter "All" menampilkan semua order', () {
      provider.updateStatusFilter('All');

      expect(provider.filteredOrders.length, 3);
    });

    // ── Search query ──────────────────────────────────────────────────────

    test('search berdasarkan nama pelanggan (case-insensitive)', () {
      provider.updateStatusFilter('All');
      provider.updateSearchQuery('andi');

      expect(provider.filteredOrders.length, 1);
      expect(provider.filteredOrders.first.customerName, 'Andi Cahyono');
    });

    test('search berdasarkan cartId', () {
      provider.updateStatusFilter('All');
      provider.updateSearchQuery('c-003');

      expect(provider.filteredOrders.length, 1);
      expect(provider.filteredOrders.first.cartId, 'c-003');
    });

    test('search yang tidak cocok menghasilkan list kosong', () {
      provider.updateStatusFilter('All');
      provider.updateSearchQuery('zzz_tidak_ada');

      expect(provider.filteredOrders, isEmpty);
    });

    test('search kosong menampilkan semua order sesuai status filter', () {
      provider.updateStatusFilter('All');
      provider.updateSearchQuery('');

      expect(provider.filteredOrders.length, 3);
    });

    // ── Kombinasi search + status ─────────────────────────────────────────

    test(
      'kombinasi search "citra" + filter "Pending" mengembalikan 1 order',
      () {
        provider.updateStatusFilter('Pending');
        provider.updateSearchQuery('citra');

        expect(provider.filteredOrders.length, 1);
        expect(provider.filteredOrders.first.customerName, 'Citra Dewi');
      },
    );

    test('kombinasi search "andi" + filter "Paid" mengembalikan 0 order', () {
      provider.updateStatusFilter('Paid');
      provider.updateSearchQuery('andi');

      expect(provider.filteredOrders, isEmpty);
    });

    // ── selectedFilter ────────────────────────────────────────────────────

    test('selectedFilter diperbarui saat updateStatusFilter dipanggil', () {
      provider.updateStatusFilter('Paid');

      expect(provider.selectedFilter, 'Paid');
    });

    // ── notifyListeners ───────────────────────────────────────────────────

    test('updateSearchQuery() memanggil notifyListeners', () {
      int count = 0;
      provider.addListener(() => count++);

      provider.updateSearchQuery('test');

      expect(count, greaterThan(0));
    });

    test('updateStatusFilter() memanggil notifyListeners', () {
      int count = 0;
      provider.addListener(() => count++);

      provider.updateStatusFilter('All');

      expect(count, greaterThan(0));
    });
  });
}
