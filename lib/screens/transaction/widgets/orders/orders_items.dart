import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_coffee_shop/providers/orders_provider.dart';

class OrdersItemsWidget extends StatefulWidget {
  const OrdersItemsWidget({super.key});
  @override
  _OrdersItemsWidgetState createState() => _OrdersItemsWidgetState();
}

class _OrdersItemsWidgetState extends State<OrdersItemsWidget> {
  @override
  Widget build(BuildContext context) {
    return Provider<OrdersProvider>(
      create: (context) => OrdersProvider(),
      child: Consumer<OrdersProvider>(
        builder: (context, ordersProvider, child) {
          return FutureBuilder(
            future:
                ordersProvider
                    .fetchOrders(), // Replace with your actual future method
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('No orders available'));
              } else {
                return Card();
              }
            },
          );
        },
      ),
    );
  }
}
