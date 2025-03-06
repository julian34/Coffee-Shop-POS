class CartItem {
  final String productId;
  final String name;
  final double price;
  int quantity;
  final String image;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'subtotal': price * quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      productId: map['productId'],
      name: map['name'],
      price: map['price'],
      quantity: map['quantity'],
      image: map['image'],
    );
  }
}
