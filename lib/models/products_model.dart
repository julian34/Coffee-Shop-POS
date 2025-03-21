import 'package:pos_coffee_shop/untils/format_utils.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String image;
  final List<ProductPrice> prices;

  //add prices for products
  // final List<ProductPrice> prices;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.prices,
  });

  //Check if the product has multiple pricing options
  bool get hasMultiplePrices => prices.length > 1;

  //Get a dynamic label based on available prices
  String get dynamicPriceLabel {
    if (prices.isEmpty) return "Price Unavailable";
    return prices
        .map((p) => '${p.label} : \ ${formatCurrency(p.amount)}')
        .join(' | ');
  }

  //Get the default price (first option)
  double get defaultPrice => prices.isNotEmpty ? prices.first.amount : 0.0;

  // Factory constructor to convert Firestore document into Product object
  factory Product.fromFirestore(Map<String, dynamic> data, String docId) {
    return Product(
      id: docId,
      name: data['name'] ?? 'Unknown',
      category: data['category'] ?? 'Unknown',
      // price: (data['price'] ?? 0).toDouble(),
      price: _parsePrice(data['price']),
      image: data['image'] ?? '',
      prices:
          (data['prices'] as List<dynamic>?)
              ?.map((p) => ProductPrice.fromMap(p))
              .toList() ??
          [ProductPrice(label: 'Default', amount: _parsePrice(data['price']))],
    );
  }

  static double _parsePrice(dynamic price) {
    if (price is num) {
      return price.toDouble(); // Handles int and double
    }
    if (price is String) {
      return double.tryParse(price) ?? 0.0; // Handles string conversion
    }
    return 0.0; // Default if null or unknown type
  }
}

class ProductPrice {
  final String label;
  final double amount;

  ProductPrice({required this.label, required this.amount});

  factory ProductPrice.fromMap(Map<String, dynamic> data) {
    return ProductPrice(
      label: data['label'] ?? 'Unknown',
      amount: Product._parsePrice(data['amount']),
    );
  }

  Map<String, dynamic> toMap() {
    return {'label': label, 'amount': amount};
  }

  factory ProductPrice.empty() {
    return ProductPrice(label: '', amount: 0.0);
  }
}
