class CartItem {
  final String id;
  final String name;
  final String image;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'total': total,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map, String docId) {
    return CartItem(
      id: docId,
      name: map['name'],
      image: map['image'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
    );
  }
}
