import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/routes.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/models/cart_model.dart';
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
      }
      // Restore cart items if needed
      // final cartItems =
      //     cartProvider.items.values.map((item) => item.toMap()).toList();
      // if (widget.order!.items.length != cartItems.length) {
      //   // cartProvider.items.clear();
      //   for (var item in widget.order!.items) {
      //     cartProvider.addToCart(item);
      //     cartProvider.updateQuantity(item.productId, item.quantity);
      //   }
      // }

      // if (widget.order != null) {
      //   syncCartWithOrder(widget.order!, cartProvider);
      // }
      if (widget.order != null) {
        syncCartWithOrder(widget.order!, cartProvider);
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
                  cartProvider.clearCart();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.order,
                    (route) => false,
                  );
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
        final baseOrder = widget.order ?? OrderList.empty();
        final currentOrder = OrderList(
          cartId: baseOrder.cartId,
          customerName:
              customerNameController.text.isNotEmpty
                  ? customerNameController.text
                  : baseOrder.customerName,
          totalAmount: cartProvider.totalAmount,
          isPaid: baseOrder.isPaid,
          paid: baseOrder.paid,
          paymentMode: paymentMode,
          status: baseOrder.status,
          createdAt: baseOrder.createdAt,
          items: cartProvider.items.values.toList(),
        );

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
              cartId: currentOrder.cartId,
              existing: currentOrder,
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
                      Expanded(
                        child: Container(
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

              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);

              await cartProvider.saveCart(
                cartId,
                customerNameController.text,
                paid: false,
                paymentMode: paymentMode,
              );

              if (mounted) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      "Order ${isNewOrder ? 'Created' : 'Updated'} Successfully!",
                    ),
                  ),
                );
                navigator.pushNamed(AppRoutes.order);
              }
            },
            order: currentOrder,
            cart: cartProvider,
            customerNameController: customerNameController,
          ),
        );
      },
    );
  }
}

void syncCartWithOrder(OrderList orderList, CartProvider cartProvider) {
  final cartItems =
      cartProvider.items.values.map((item) => item.toMap()).toList();

  bool needsSync =
      orderList.items.length != cartItems.length ||
      !_areItemsEqual(orderList.items, cartItems);

  if (needsSync) {
    // /cartProvider.clearCart
    cartProvider.clearCart();
    for (var item in orderList.items) {
      cartProvider.addToCart(item);
    }
  }
}

bool _areItemsEqual(
  List<CartItem> orderItems,
  List<Map<String, dynamic>> cartItems,
) {
  if (orderItems.length != cartItems.length) return false;

  for (var item in orderItems) {
    final match = cartItems.firstWhere(
      (cartItem) => cartItem['productId'] == item.productId,
      orElse: () => {},
    );
    if (match.isEmpty || match['quantity'] != item.quantity) {
      return false;
    }
  }
  return true;
}
