class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
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
