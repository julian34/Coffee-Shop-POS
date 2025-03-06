import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:pos_coffee_shop/screens/cart/widgets/child/itemcart/itemcard.dart';

class ItemCartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        var item = cart.items.values.toList()[index];
        return Itemcard(item: item);
      },
    );
  }
}
