import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';

class BottomNavBar extends StatelessWidget {
  final CartProvider cart;
  final TextEditingController consumerNameController;

  const BottomNavBar({
    super.key,
    required this.cart,
    required this.consumerNameController,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 5.0,
      color: AppColors.color3,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: ElevatedButton(
          onPressed:
              cart.items.isEmpty
                  ? null
                  : () async {
                    String cartId =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    await cart.saveCart(
                      cartId,
                      consumerNameController.text,
                      paid: false,
                      paymentMode: '',
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Cart seved!')));
                  },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: Text(
            cart.items.isEmpty ? "Please add items" : "Prosess Order",
            style: TextStyle(
              fontSize: 20,
              color: AppColors.color4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
