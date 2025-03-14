import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/routes.dart';
import 'package:pos_coffee_shop/untils/format_utils.dart';
import 'package:provider/provider.dart';
import 'package:pos_coffee_shop/providers/orders_provider.dart';
import 'package:pos_coffee_shop/models/order_model.dart';

class OrdersItemsWidget extends StatelessWidget {
  const OrdersItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final List<OrderList> orders = orderProvider.filteredOrders;

    return Expanded(
      child:
          orders.isEmpty
              ? Center(
                child: Text(
                  "No orders available",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return GestureDetector(
                    onTap: () {
                      if (order.paid) {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.orderDetail,
                          arguments: order,
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.cart,
                          arguments: order,
                        );
                      }
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(
                          "Order No: ${order.cartId}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Customer: ${order.customerName}"),
                            Text(
                              "Total Amount: ${formatCurrency(order.totalAmount)}",
                            ),
                            Text("Payment Mode: ${order.paymentMode}"),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: order.paid ? Colors.green : Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            order.paid ? "Paid" : "Pending",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
