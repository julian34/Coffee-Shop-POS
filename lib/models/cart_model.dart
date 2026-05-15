import 'package:pos_coffee_shop/models/products_model.dart';

class CartItem {
  final String productId;
  final String name;
  final double price;
  final String label;
  final ProductPrice selectedPrice;
  int quantity;
  final String image;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.label,
    required this.selectedPrice,
    this.quantity = 1,
    required this.image,
  });

  String get uniqueKey => '$productId-$label';
  CartItem copyWith({
    String? productId,
    String? name,
    double? price,
    ProductPrice? selectedPrice,
    String? label,
    int? quantity,
    String? image,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      label: label ?? this.label,
      quantity: quantity ?? this.quantity,
      selectedPrice: selectedPrice ?? this.selectedPrice,
      image: image ?? this.image,
    );
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    print("CartItem map: $map");
    final selectedPriceData = map['selectedPrice'];
    final ProductPrice selectedPrice =
        (selectedPriceData is Map<String, dynamic>)
            ? ProductPrice.fromMap(selectedPriceData)
            : ProductPrice.empty();

    return CartItem(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      label: map['label'] ?? '',
      selectedPrice: selectedPrice,
      quantity: (map['quantity'] ?? 1).toInt(),
      image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'selectedPrice': {
        'label': selectedPrice.label,
        'amount': selectedPrice.amount,
      },
      'label': label,
      'quantity': quantity,
      'subtotal': selectedPrice.amount * quantity,
      'image': image,
    };
  }
}
