import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:pos_coffee_shop/screens/cart/widgets/child/itemcart/itemcard.dart';

class ItemCartWidget extends StatelessWidget {
  const ItemCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        var item = cart.items.values.toList()[index];
        // return Itemcard(item: item);
        return Dismissible(
          // key: Key(item.productId),
          key: Key(item.uniqueKey),
          direction: DismissDirection.endToStart,
          background: Container(
            // decoration: BoxDecoration(border: Border()),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: AppColors.color6,
            child: Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            cart.removeItem(item.uniqueKey);
          },
          child: Itemcard(item: item),
        );
      },
    );
  }
}
