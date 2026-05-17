import 'package:flutter_test/flutter_test.dart';
import 'package:pos_coffee_shop/models/products_model.dart';

void main() {
  group('ProductPrice', () {
    test('fromMap() membuat ProductPrice dengan benar', () {
      final result = ProductPrice.fromMap({'label': 'Large', 'amount': 35000});

      expect(result.label, 'Large');
      expect(result.amount, 35000.0);
    });

    test('fromMap() menggunakan default saat field null', () {
      final result = ProductPrice.fromMap({});

      expect(result.label, 'Unknown');
      expect(result.amount, 0.0);
    });

    test('fromMap() mengkonversi String ke double untuk amount', () {
      final result = ProductPrice.fromMap({'label': 'M', 'amount': '28000'});

      expect(result.amount, 28000.0);
    });

    test(
      'empty() menghasilkan ProductPrice dengan label kosong dan amount 0',
      () {
        final result = ProductPrice.empty();

        expect(result.label, '');
        expect(result.amount, 0.0);
      },
    );

    test('toMap() mengembalikan map yang benar', () {
      final price = ProductPrice(label: 'Hot', amount: 22000);

      final map = price.toMap();

      expect(map['label'], 'Hot');
      expect(map['amount'], 22000.0);
    });
  });

  group('Product', () {
    final tPrices = [
      ProductPrice(label: 'Small', amount: 20000),
      ProductPrice(label: 'Medium', amount: 25000),
      ProductPrice(label: 'Large', amount: 30000),
    ];

    final tProduct = Product(
      id: 'prod-001',
      name: 'Cappuccino',
      category: 'Coffee',
      price: 25000,
      image: 'assets/cappuccino.png',
      prices: tPrices,
    );

    // ── fromFirestore ─────────────────────────────────────────────────────

    test('fromFirestore() membuat Product dengan benar dari data map', () {
      final data = {
        'name': 'Americano',
        'category': 'Coffee',
        'price': 18000,
        'image': 'assets/americano.png',
        'prices': [
          {'label': 'Regular', 'amount': 18000},
        ],
      };

      final result = Product.fromFirestore(data, 'doc-001');

      expect(result.id, 'doc-001');
      expect(result.name, 'Americano');
      expect(result.category, 'Coffee');
      expect(result.price, 18000.0);
      expect(result.prices.length, 1);
      expect(result.prices.first.label, 'Regular');
    });

    test('fromFirestore() menggunakan default harga saat prices null', () {
      final data = {
        'name': 'Teh Manis',
        'category': 'Non-Coffee',
        'price': 10000,
      };

      final result = Product.fromFirestore(data, 'doc-002');

      expect(result.prices.length, 1);
      expect(result.prices.first.label, 'Default');
      expect(result.prices.first.amount, 10000.0);
    });

    test('fromFirestore() mengkonversi String price ke double', () {
      final data = {'name': 'Latte', 'price': '27000', 'prices': []};

      final result = Product.fromFirestore(data, 'doc-003');

      expect(result.price, 27000.0);
    });

    test(
      'fromFirestore() menggunakan nilai default saat name dan category null',
      () {
        final result = Product.fromFirestore({}, 'doc-empty');

        expect(result.name, 'Unknown');
        expect(result.category, 'Unknown');
        expect(result.image, '');
      },
    );

    // ── hasMultiplePrices ─────────────────────────────────────────────────

    test(
      'hasMultiplePrices mengembalikan true saat ada lebih dari 1 harga',
      () {
        expect(tProduct.hasMultiplePrices, true);
      },
    );

    test('hasMultiplePrices mengembalikan false saat hanya 1 harga', () {
      final p = Product(
        id: 'x',
        name: 'x',
        category: 'x',
        price: 10000,
        image: '',
        prices: [ProductPrice(label: 'Regular', amount: 10000)],
      );

      expect(p.hasMultiplePrices, false);
    });

    // ── defaultPrice ──────────────────────────────────────────────────────

    test('defaultPrice mengembalikan amount dari harga pertama', () {
      expect(tProduct.defaultPrice, 20000.0);
    });

    test('defaultPrice mengembalikan 0.0 saat prices kosong', () {
      final p = Product(
        id: 'x',
        name: 'x',
        category: 'x',
        price: 0,
        image: '',
        prices: [],
      );

      expect(p.defaultPrice, 0.0);
    });

    // ── dynamicPriceLabel ─────────────────────────────────────────────────

    test('dynamicPriceLabel mengandung semua label harga', () {
      final label = tProduct.dynamicPriceLabel;

      expect(label, contains('Small'));
      expect(label, contains('Medium'));
      expect(label, contains('Large'));
    });

    test(
      'dynamicPriceLabel mengembalikan "Price Unavailable" saat prices kosong',
      () {
        final p = Product(
          id: 'x',
          name: 'x',
          category: 'x',
          price: 0,
          image: '',
          prices: [],
        );

        expect(p.dynamicPriceLabel, 'Price Unavailable');
      },
    );

    // ── _parsePrice edge cases ─────────────────────────────────────────────

    test('fromFirestore() mengembalikan 0.0 untuk price yang tidak valid', () {
      final data = {'name': 'X', 'price': 'bukan_angka'};

      final result = Product.fromFirestore(data, 'doc-nan');

      expect(result.price, 0.0);
    });
  });
}
