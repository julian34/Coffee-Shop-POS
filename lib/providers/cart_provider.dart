import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, List<CartItem>> _carts = {};
  final Map<String, String> _consumerNames = {};

  String? _currentCartId;
  bool isEditingCN = false;

  String? get currentCartId => _currentCartId;

  List<CartItem> getItems(String cartId) => _carts[cartId] ?? [];
  double getTotalPrice(String cartId) =>
      _carts[cartId]?.fold(0, (total, item) => total! + item.total) ?? 0.0;
  int getItemCount(String cartId) =>
      _carts[cartId]?.fold(0, (count, item) => count! + item.quantity) ?? 0;
  String getConsumerName(String cartId) => _consumerNames[cartId] ?? "Guest";

  void addToCart(String cartId, CartItem item) {
    _carts.putIfAbsent(cartId, () => []);
    int index = _carts[cartId]!.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _carts[cartId]![index] = _carts[cartId]![index].copyWith(
        quantity: _carts[cartId]![index].quantity + item.quantity,
      );
    } else {
      _carts[cartId]!.add(item);
    }
    notifyListeners();
  }

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
}
