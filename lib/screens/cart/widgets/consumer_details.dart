import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_coffee_shop/screens/cart/widgets/box_consumer.dart';
import 'package:pos_coffee_shop/screens/cart/widgets/box_edit_consumer.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';

class ConsumerDetailsTab extends StatelessWidget {
  final String cartId; // ✅ Accept cartId

  const ConsumerDetailsTab({super.key, required this.cartId});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, provider, child) {
        return provider.isEditingCN
            ? BoxEditConsumer(cartId: cartId) // ✅ Ensure cartId is passed
            : BoxConsumer(cartId: cartId); // ✅ Ensure cartId is passed
      },
    );
  }
}
