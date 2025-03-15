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
  final OrderList? order;
  const CartScreen({super.key, this.order});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late TextEditingController customerNameController;
  String paymentMode = 'Cash';
  bool paid = false;
  bool isControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    customerNameController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);

      if (widget.order != null) {
        customerNameController.text =
            widget.order!.customerName.isNotEmpty
                ? widget.order!.customerName
                : 'Guest';

        // Restore cart items if needed
        final cartItems =
            cartProvider.items.values.map((item) => item.toMap()).toList();
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
          customerNameController.text = widget.order!.customerName;
        });
      }

      setState(() {
        isControllerInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    customerNameController.dispose();
    super.dispose();
  }

  void _showConfirmationDialog(
    BuildContext context,
    CartProvider cartProvider,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.exit_to_app, color: AppColors.color6),
                const SizedBox(width: 10),
                const Text('Cancel'),
              ],
            ),
            content: const Text(
              'Are you sure you want to cancel the cart update? Any unsaved changes will be lost.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  cartProvider.items.clear();
                  Navigator.pushNamed(context, AppRoutes.order);
                },
                child: const Text('Exit'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        if (!isControllerInitialized) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final isNewOrder = widget.order == null || widget.order!.cartId.isEmpty;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: CartAppbar(
              onPressed: () {
                if (!isNewOrder) {
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
                      paid: false,
                      paymentMode: 'Cash',
                      status: 'Pending',
                      createdAt: DateTime.now(),
                      items: [],
                    ),
                  );
                }
              },
              titleScreen: isNewOrder ? 'Cart' : 'Checkout',
              cartId: widget.order?.cartId ?? '',
              existing: widget.order,
            ),
          ),
          body:
              cartProvider.items.isEmpty
                  ? const BodyCartEmpty()
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConsumerDetailsTab(controller: customerNameController),
                      const NoteTab(),
                      Flexible(
                        child: Container(
                          height: 345,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const ItemCartWidget(),
                        ),
                      ),
                      OrderSummaryTab(totalAmount: cartProvider.totalAmount),
                    ],
                  ),
          bottomNavigationBar: BottomNavBar(
            onPressed: () async {
              final cartId =
                  isNewOrder
                      ? DateTime.now().millisecondsSinceEpoch.toString()
                      : widget.order!.cartId;

              await cartProvider.saveCart(
                cartId,
                customerNameController.text,
                paid: false,
                paymentMode: paymentMode,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Order ${isNewOrder ? 'Created' : 'Updated'} Successfully!",
                  ),
                ),
              );
              Navigator.pushNamed(context, AppRoutes.order);
            },
            order: widget.order ?? OrderList.empty(),
            cart: cartProvider,
            customerNameController: customerNameController,
          ),
        );
      },
    );
  }
}
