import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/services/cart_service.dart';
import 'package:pos_coffee_shop/models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();
  final Map<String, List<CartItem>> _carts = {};
  final Map<String, String> _consumerNames = {};

  String? currentCartId;
  bool isEditingCN = false;

  Future<void> addToCart(String cartId, CartItem item) async {
    if (cartId == "default_cart_id" || cartId.isEmpty) {
      createNewCart();
      cartId = currentCartId!;
    }
    await _cartService.addToCart(cartId, item);
    if (!_carts.containsKey(cartId)) {
      _carts[cartId] = [];
    }
    _carts[cartId]!.add(item);
    print("🛠️ Debug: Adding to Cart - cartId: $cartId, Item: ${item.name}");
    notifyListeners();
  }

  List<CartItem> getItems(String cartId) => _carts[cartId] ?? [];
  double getTotalPrice(String cartId) =>
      _carts[cartId]?.fold(0, (total, item) => total! + item.total) ?? 0.0;
  int getItemCount(String cartId) =>
      _carts[cartId]?.fold(0, (count, item) => count! + item.quantity) ?? 0;
  String getConsumerName(String cartId) => _consumerNames[cartId] ?? "Guest";

  void updateQuantity(String cartId, String itemId, int newQuantity) {
    if (!_carts.containsKey(cartId)) return;
    int index = _carts[cartId]!.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (newQuantity > 0) {
        _carts[cartId]![index] = _carts[cartId]![index].copyWith(
          quantity: newQuantity,
        );
      } else {
        _carts[cartId]!.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeFromCart(String cartId, String itemId) {
    _carts[cartId]?.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void clearCart(String cartId) {
    _carts.remove(cartId);
    notifyListeners();
  }

  void submitConsumerName(String cartId, String name) {
    setConsumerName(cartId, name);
    notifyListeners();
  }

  void setConsumerName(String cartId, String name) {
    _consumerNames[cartId] = name;
    isEditingCN = false;
    notifyListeners();
  }

  void toggleEditingCN() {
    isEditingCN = !isEditingCN;
    notifyListeners();
  }

  void setCurrentCartId(String cartId) {
    currentCartId = cartId;
    notifyListeners();
    print("🛠️ Debug: Cart ID Set - $currentCartId");
  }

  void createNewCart() {
    String newCartId = "cart_${DateTime.now().millisecondsSinceEpoch}";
    _carts[newCartId] = [];
    currentCartId = newCartId; // ✅ Set the new cart ID
    notifyListeners();
    print("🛠️ Debug: New Cart Created - cartId: $currentCartId");
  }
}
