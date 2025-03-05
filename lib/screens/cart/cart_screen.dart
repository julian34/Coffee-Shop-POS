import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/models/cart_model.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

import 'widgets/custom_appbar.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/consumer_details.dart';
import 'widgets/notetab.dart';
import 'widgets/order_summary.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final cartItems = cartProvider.items;
        final bool isCartEmpty = cartItems.isEmpty;
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(120),
            child: CartAppbar(),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!cartItems.isEmpty) ConsumerDetailsTab(),
              if (!cartItems.isEmpty) NoteTab(),
              Container(
                height: 320,
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                // decoration: BoxDecoration(color: AppColors.color3),
                child:
                    cartItems.isEmpty
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image.asset("assets/images/none_items.png"),
                            SizedBox(height: 10),
                            Text(
                              "Item Empty",
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                        : ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            CartItem item = cartItems[index];
                            return Dismissible(
                              key: Key(item.id),
                              direction:
                                  DismissDirection
                                      .endToStart, // Swipe left to delete
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              onDismissed: (direction) {
                                cartProvider.removeFromCart(item.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "${item.name} removed from cart",
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                leading: Image.network(
                                  item.image,
                                  width: 50,
                                  height: 50,
                                ),
                                title: Text(item.name),
                                subtitle: Text(
                                  "Rp. ${item.price.toStringAsFixed(2)} x ${item.quantity}",
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed:
                                          () => cartProvider.updateQuantity(
                                            item.id,
                                            item.quantity - 1,
                                          ),
                                    ),
                                    Text(item.quantity.toString()),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed:
                                          () => cartProvider.updateQuantity(
                                            item.id,
                                            item.quantity + 1,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
              if (!cartItems.isEmpty) OrderSummaryTab(),
            ],
          ),
          bottomNavigationBar: BottomNavBar(isCartEmpty: isCartEmpty),
        );
      },
    );
  }
}
