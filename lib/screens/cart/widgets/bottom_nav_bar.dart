import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/routes.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/models/order_model.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';
import 'package:pos_coffee_shop/providers/orders_provider.dart';

class BottomNavBar extends StatefulWidget {
  final CartProvider cart;
  final TextEditingController consumerNameController;
  final VoidCallback onPressed;
  final OrderList order;

  const BottomNavBar({
    super.key,
    required this.onPressed,
    required this.order,
    required this.cart,
    required this.consumerNameController,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 5.0,
      color: AppColors.color3,
      child:
          widget.order.cartId.isNotEmpty
              ? prosessCheckout()
              : prosessOrder(
                onPressed: widget.onPressed,
                cart: widget.cart,
                consumerNameController: widget.consumerNameController.text,
              ),

      // Container(
      //   padding: EdgeInsets.symmetric(horizontal: 40),
      //   child: ElevatedButton(
      //     onPressed: cart.items.isEmpty ? null : onPressed,
      //     // : () async {
      //     //   String cartId =
      //     //       DateTime.now().millisecondsSinceEpoch.toString();
      //     //   await cart.saveCart(
      //     //     cartId,
      //     //     consumerNameController.text,
      //     //     paid: false,
      //     //     paymentMode: '',
      //     //   );
      //     //   Navigator.pop(context);
      //     //   ScaffoldMessenger.of(
      //     //     context,
      //     //   ).showSnackBar(SnackBar(content: Text('Cart seved!')));
      //     // },
      //     style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
      //     child: Text(
      //       cart.items.isEmpty ? "Please add items" : "Prosess Order",
      //       style: TextStyle(
      //         fontSize: 20,
      //         color: AppColors.color4,
      //         fontWeight: FontWeight.w700,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}

class prosessOrder extends StatelessWidget {
  final VoidCallback onPressed;
  final CartProvider cart;
  final String consumerNameController;
  const prosessOrder({
    super.key,
    required this.onPressed,
    required this.cart,
    required this.consumerNameController,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed:
              cart.items.isEmpty
                  ? null
                  : () async {
                    String cartId =
                        DateTime.now().microsecondsSinceEpoch.toString();

                    var cartData = {
                      'cartId': cartId,
                      'consumerName': consumerNameController,
                      'paid': false,
                      'paymentMode': "",
                    };
                    _saveCart(context, cartData, cart);
                  },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: Text(
            'Prosess Order',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.color4,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> _saveCart(
  context,
  Map<String, dynamic> cartData,
  CartProvider cart,
) async {
  try {
    print(cartData);
    _showLoadingDialog(context);
    //save cart
    cart.saveCart(
      cartData['cartId'],
      cartData['consumerName'],
      paid: cartData['paid'],
      paymentMode: cartData['paymentMode'],
    );
    await Future.delayed(Duration(seconds: 2));
    _showMassage(context, 'Cart saved successfully!', AppColors.color7);
    Navigator.pushReplacementNamed(context, AppRoutes.cashierHome);
  } catch (e) {
    Navigator.pop(context);
    _showMassage(context, 'Failed to save cart: $e', AppColors.color6);
  }
}

void _showMassage(BuildContext context, String message, color) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
}

void _showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Saving..."),
            ],
          ),
        ),
  );
}

class prosessCheckout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row();
  }
}
