import 'package:flutter_test/flutter_test.dart';
import 'package:pos_coffee_shop/models/cart_model.dart';
import 'package:pos_coffee_shop/models/products_model.dart';

void main() {
  group('CartItem', () {
    final tProductPrice = ProductPrice(label: 'Regular', amount: 25000);

    final tCartItem = CartItem(
      productId: 'prod-001',
      name: 'Kopi Susu',
      price: 25000,
      label: 'Regular',
      selectedPrice: tProductPrice,
      quantity: 2,
      image: 'assets/kopi.png',
    );

    // ── fromMap ───────────────────────────────────────────────────────────

    test('fromMap() membuat CartItem dengan nilai yang benar', () {
      final map = {
        'productId': 'prod-001',
        'name': 'Kopi Susu',
        'price': 25000,
        'label': 'Regular',
        'selectedPrice': {'label': 'Regular', 'amount': 25000},
        'quantity': 2,
        'image': 'assets/kopi.png',
      };

      final result = CartItem.fromMap(map);

      expect(result.productId, 'prod-001');
      expect(result.name, 'Kopi Susu');
      expect(result.price, 25000.0);
      expect(result.label, 'Regular');
      expect(result.quantity, 2);
      expect(result.image, 'assets/kopi.png');
      expect(result.selectedPrice.label, 'Regular');
      expect(result.selectedPrice.amount, 25000.0);
    });

    test('fromMap() menggunakan nilai default saat field kosong/null', () {
      final result = CartItem.fromMap({});

      expect(result.productId, '');
      expect(result.name, '');
      expect(result.price, 0.0);
      expect(result.label, '');
      expect(result.quantity, 1);
      expect(result.image, '');
      expect(result.selectedPrice.label, '');
      expect(result.selectedPrice.amount, 0.0);
    });

    test(
      'fromMap() mengkonversi selectedPrice yang bukan Map menjadi empty()',
      () {
        final map = {
          'productId': 'prod-002',
          'selectedPrice': 'invalid_type',
          'quantity': 1,
        };

        final result = CartItem.fromMap(map);

        expect(result.selectedPrice.label, '');
        expect(result.selectedPrice.amount, 0.0);
      },
    );

    // ── toMap ─────────────────────────────────────────────────────────────

    test('toMap() mengembalikan map dengan field yang benar', () {
      final map = tCartItem.toMap();

      expect(map['productId'], 'prod-001');
      expect(map['name'], 'Kopi Susu');
      expect(map['price'], 25000.0);
      expect(map['label'], 'Regular');
      expect(map['quantity'], 2);
      expect(map['image'], 'assets/kopi.png');
      expect(map['selectedPrice'], isA<Map>());
    });

    test('toMap() menghitung subtotal dengan benar (amount * quantity)', () {
      final map = tCartItem.toMap();

      expect(map['subtotal'], 25000.0 * 2);
    });

    // ── uniqueKey ─────────────────────────────────────────────────────────

    test('uniqueKey mengembalikan format productId-label', () {
      expect(tCartItem.uniqueKey, 'prod-001-Regular');
    });

    test('uniqueKey unik untuk produk yang sama dengan label berbeda', () {
      final itemSmall = CartItem(
        productId: 'prod-001',
        name: 'Kopi Susu',
        price: 20000,
        label: 'Small',
        selectedPrice: ProductPrice(label: 'Small', amount: 20000),
        image: '',
      );
      final itemLarge = CartItem(
        productId: 'prod-001',
        name: 'Kopi Susu',
        price: 30000,
        label: 'Large',
        selectedPrice: ProductPrice(label: 'Large', amount: 30000),
        image: '',
      );

      expect(itemSmall.uniqueKey, isNot(equals(itemLarge.uniqueKey)));
    });

    // ── copyWith ──────────────────────────────────────────────────────────

    test('copyWith() mengganti field yang diberikan', () {
      final updated = tCartItem.copyWith(quantity: 5, name: 'Matcha Latte');

      expect(updated.quantity, 5);
      expect(updated.name, 'Matcha Latte');
    });

    test('copyWith() mempertahankan field yang tidak diberikan', () {
      final updated = tCartItem.copyWith(quantity: 3);

      expect(updated.productId, tCartItem.productId);
      expect(updated.price, tCartItem.price);
      expect(updated.label, tCartItem.label);
      expect(updated.image, tCartItem.image);
    });

    // ── round-trip ────────────────────────────────────────────────────────

    test('fromMap(toMap()) menghasilkan objek yang ekuivalen', () {
      final map = tCartItem.toMap();
      final restored = CartItem.fromMap(map);

      expect(restored.productId, tCartItem.productId);
      expect(restored.name, tCartItem.name);
      expect(restored.price, tCartItem.price);
      expect(restored.label, tCartItem.label);
      expect(restored.quantity, tCartItem.quantity);
      expect(restored.selectedPrice.label, tCartItem.selectedPrice.label);
      expect(restored.selectedPrice.amount, tCartItem.selectedPrice.amount);
    });
  });
}
