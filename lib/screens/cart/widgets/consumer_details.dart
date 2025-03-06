import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_coffee_shop/screens/cart/widgets/box_consumer.dart';
// import 'package:pos_coffee_shop/screens/cart/widgets/box_edit_consumer.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';

class ConsumerDetailsTab extends StatelessWidget {
  const ConsumerDetailsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, provider, child) {
        return
        // BoxEditConsumer()
        BoxConsumer();
      },
    );
  }
}
