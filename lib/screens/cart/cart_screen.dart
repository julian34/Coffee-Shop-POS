import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final cartItems = cartProvider.items;

        return Scaffold(
          appBar: AppBar(title: Text("Cart")),
          body:
              cartItems.isEmpty
                  ? Center(child: Text("Your cart is empty"))
                  : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      CartItem item = cartItems[index];

                      return Dismissible(
                        key: Key(item.id),
                        direction:
                            DismissDirection.endToStart, // Swipe left to delete
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
                              content: Text("${item.name} removed from cart"),
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
          bottomNavigationBar:
              cartItems.isNotEmpty
                  ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        cartProvider.clearCart();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Cart cleared!")),
                        );
                      },
                      child: Text("Checkout"),
                    ),
                  )
                  : null,
        );
      },
    );
  }
}
