import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/routes.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/models/order_model.dart';
import 'package:provider/provider.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';
import 'package:pos_coffee_shop/screens/cart/widgets/body_cart_empty.dart';

import 'widgets/custom_appbar.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/consumer_details.dart';
import 'widgets/notetab.dart';
import 'widgets/order_summary.dart';
import 'widgets/item_cart.dart';

class CartScreen extends StatefulWidget {
  final OrderList? order; //new add | If null, it's a new cart
  const CartScreen({super.key, this.order});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String paymentMode = 'Cash'; // new add | Default Payment Mode
  bool paid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      if (widget.order != null) {
        final cartItems =
            cartProvider.items.values
                .map((itemcart) => itemcart.toMap())
                .toList();
        if (widget.order!.items.length != cartItems.length) {
          cartProvider.items.clear();
          for (var item in widget.order!.items) {
            cartProvider.addToCart(item);
            cartProvider.updateQuantity(item.productId, item.quantity);
          }
        }
        setState(() {
          paid = widget.order!.isPaid;
          paymentMode = widget.order!.paymentMode;
        });
      }
    });
  }

  void _showConfirmationDialog(
    BuildContext context,
    CartProvider cartProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.exit_to_app, color: AppColors.color6),
              SizedBox(width: 10),
              Text('Cancel'),
            ],
          ),
          content: Text(
            'Are you sure you want to cancel the cart update? Any unsaved changes will be lost.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                cartProvider.items.clear();
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.order);
              },
              child: Text('Exit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController consumerNameController = TextEditingController(
      text:
          widget.order!.customerName.isEmpty ? '' : widget.order!.customerName,
    );

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(120),
            child: CartAppbar(
              onPressed: () async {
                if (widget.order!.cartId != '') {
                  print(widget.order!.cartId);
                  _showConfirmationDialog(context, cartProvider);
                } else {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.cashierHome,
                    arguments: OrderList(
                      cartId: '',
                      customerName: '',
                      totalAmount: 0,
                      isPaid: false,
                      paymentMode: 'Cash',
                      status: 'Peding',
                      createdAt: DateTime.timestamp(),
                      items: [],
                    ),
                  );
                }
              },
              titleScreen: widget.order!.cartId == '' ? 'Cart' : 'Checkout',
              cartId: widget.order!.cartId,
              existing: widget.order,
            ),
          ),
          body:
              cartProvider.items.isEmpty
                  ? BodyCartEmpty()
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConsumerDetailsTab(controller: consumerNameController),
                      NoteTab(),
                      Flexible(
                        child: Container(
                          height: 345,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: ItemCartWidget(),
                        ),
                      ),
                      OrderSummaryTab(totalAmount: cartProvider.totalAmount),
                    ],
                  ),
          bottomNavigationBar: BottomNavBar(
            onPressed: () async {
              String cartId =
                  widget.order!.cartId.isEmpty
                      ? DateTime.now().millisecondsSinceEpoch.toString()
                      : widget.order!.cartId;
              await cartProvider.saveCart(
                cartId,
                consumerNameController.text,
                paid: false,
                paymentMode: "",
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Order ${widget.order!.cartId == '' ? 'Created' : 'Updated'} Successfully!",
                  ),
                ),
              );
              Navigator.pushNamed(context, AppRoutes.order);
            },
            order: widget.order!,
            cart: cartProvider,
            consumerNameController: consumerNameController,
          ),
        );
      },
    );
  }
}
