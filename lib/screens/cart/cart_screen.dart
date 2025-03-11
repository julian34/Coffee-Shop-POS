import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/routes.dart';
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
      final cartItems =
          cartProvider.items.values
              .map((itemcart) => itemcart.toMap())
              .toList();
      if (widget.order!.items.length != cartItems.length) {
        if (widget.order != null) {
          cartProvider.items.clear();
          for (var item in widget.order!.items) {
            print(item);
            cartProvider.addToCart(item);
          }
        }
        paid = widget.order!.isPaid;
        paymentMode = widget.order!.paymentMode;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _consumerNameController = TextEditingController(
      text:
          widget.order!.customerName.isEmpty ? '' : widget.order!.customerName,
    );

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(120),
            child: CartAppbar(
              onPressed: () {
                if (widget.order!.cartId != '') {
                  cartProvider.items.clear();
                }
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
                      ConsumerDetailsTab(controller: _consumerNameController),
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
                _consumerNameController.text,
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
            cart: cartProvider,
            consumerNameController: _consumerNameController,
          ),
        );
      },
    );
  }
}
