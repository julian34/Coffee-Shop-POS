import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_coffee_shop/models/cart_model.dart';
import 'package:pos_coffee_shop/models/products_model.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';
import 'package:pos_coffee_shop/services/cart_service.dart';

CartItem _makeItem({
  String productId = 'prod-001',
  String name = 'Kopi Susu',
  double price = 25000,
  String label = 'Regular',
  int quantity = 1,
}) {
  return CartItem(
    productId: productId,
    name: name,
    price: price,
    label: label,
    selectedPrice: ProductPrice(label: label, amount: price),
    quantity: quantity,
    image: '',
  );
}

void main() {
  group('CartProvider', () {
    late CartProvider provider;

    setUp(() {
      provider = CartProvider.forTest(
        cartService: CartService(FakeFirebaseFirestore()),
      );
    });

    // ── addToCart ─────────────────────────────────────────────────────────

    test('addToCart() menambahkan item baru ke cart', () {
      provider.addToCart(_makeItem());

      expect(provider.items.length, 1);
      expect(provider.items.containsKey('prod-001-Regular'), true);
    });

    test('addToCart() menggunakan uniqueKey productId-label sebagai kunci', () {
      provider.addToCart(_makeItem(productId: 'p1', label: 'Hot'));
      provider.addToCart(_makeItem(productId: 'p1', label: 'Iced'));

      expect(provider.items.length, 2);
      expect(provider.items.containsKey('p1-Hot'), true);
      expect(provider.items.containsKey('p1-Iced'), true);
    });

    test('addToCart() dengan kunci duplikat tidak menggandakan item', () {
      provider.addToCart(_makeItem());
      provider.addToCart(_makeItem()); // kunci sama

      expect(provider.items.length, 1);
    });

    // ── totalAmount ───────────────────────────────────────────────────────

    test('totalAmount menghitung price * quantity untuk semua item', () {
      provider.addToCart(_makeItem(price: 25000, quantity: 2));
      provider.addToCart(
        _makeItem(productId: 'p2', label: 'L', price: 30000, quantity: 3),
      );

      // 25000*2 + 30000*3 = 50000 + 90000 = 140000
      expect(provider.totalAmount, 140000.0);
    });

    test('totalAmount mengembalikan 0 saat cart kosong', () {
      expect(provider.totalAmount, 0.0);
    });

    // ── updateCustomerName ────────────────────────────────────────────────

    test('updateCustomerName() memperbarui nama pelanggan', () {
      provider.updateCustomerName('Budi');

      expect(provider.customerName, 'Budi');
    });

    test('customerName default adalah "Guest"', () {
      expect(provider.customerName, 'Guest');
    });

    // ── updateQuantity ────────────────────────────────────────────────────

    test('updateQuantity() mengubah jumlah item yang ada', () {
      provider.addToCart(_makeItem());

      provider.updateQuantity('prod-001-Regular', 5);

      expect(provider.items['prod-001-Regular']!.quantity, 5);
    });

    test('updateQuantity() dengan quantity <= 0 menghapus item', () {
      provider.addToCart(_makeItem());

      provider.updateQuantity('prod-001-Regular', 0);

      expect(provider.items.containsKey('prod-001-Regular'), false);
    });

    test(
      'updateQuantity() dengan kunci yang tidak ada tidak melempar error',
      () {
        expect(
          () => provider.updateQuantity('kunci-tidak-ada', 3),
          returnsNormally,
        );
      },
    );

    // ── removeItem ────────────────────────────────────────────────────────

    test('removeItem() menghapus item yang ada dari cart', () {
      provider.addToCart(_makeItem());

      provider.removeItem('prod-001-Regular');

      expect(provider.items.isEmpty, true);
    });

    test('removeItem() dengan kunci yang tidak ada tidak melempar error', () {
      expect(() => provider.removeItem('kunci-palsu'), returnsNormally);
    });

    test('removeItem() tidak menghapus item lain saat kunci berbeda', () {
      provider.addToCart(_makeItem(productId: 'p1', label: 'A'));
      provider.addToCart(_makeItem(productId: 'p2', label: 'B'));

      provider.removeItem('p1-A');

      expect(provider.items.length, 1);
      expect(provider.items.containsKey('p2-B'), true);
    });

    // ── notifyListeners ───────────────────────────────────────────────────

    test('addToCart() memanggil notifyListeners (items berubah)', () {
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      provider.addToCart(_makeItem());

      expect(notifyCount, greaterThan(0));
    });

    test('removeItem() memanggil notifyListeners saat item dihapus', () {
      provider.addToCart(_makeItem());

      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      provider.removeItem('prod-001-Regular');

      expect(notifyCount, greaterThan(0));
    });
  });
}
