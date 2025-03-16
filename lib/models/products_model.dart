import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String image;

  //add prices for products
  // final List<ProductPrice> prices;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    // required this.prices,
  });

  // Factory constructor to convert Firestore document into Product object
  factory Product.fromFirestore(Map<String, dynamic> data, String docId) {
    return Product(
      id: docId,
      name: data['name'] ?? 'Unknown',
      category: data['category'] ?? 'Unknown',
      // price: (data['price'] ?? 0).toDouble(),
      price: _parsePrice(data['price']),
      image: data['image'] ?? '',
      // prices:
      //     (data['prices'] as List<dynamic>)
      //         .map((p) => ProductPrice.fromMap(p))
      //         .toList(),
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
      label: data['lable'],
      amount: _parsePrice(data['amount']),
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
