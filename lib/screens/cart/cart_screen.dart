import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import 'package:pos_coffee_shop/screens/cart/widgets/body_cart_empty.dart';

import 'widgets/custom_appbar.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/consumer_details.dart';
import 'widgets/notetab.dart';
import 'widgets/order_summary.dart';
import 'widgets/item_cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _consumerNameController = TextEditingController(
    text: "Albert",
  );
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(120),
            child: CartAppbar(),
          ),
          body:
              cartProvider.items.isEmpty
                  ? BodyCartEmpty()
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConsumerDetailsTab(),
                      NoteTab(),
                      Container(
                        height: 345,
                        // padding: EdgeInsets.all(80),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Flexible(child: ItemCartWidget()),
                      ),
                      OrderSummaryTab(totalAmount: cartProvider.totalAmount),
                    ],
                  ),
          bottomNavigationBar: BottomNavBar(
            cart: cartProvider,
            consumerNameController: _consumerNameController,
          ),
        );
      },
    );
  }
}
