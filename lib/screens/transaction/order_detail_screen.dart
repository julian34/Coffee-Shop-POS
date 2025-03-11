import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/models/order_model.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderList order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order ID: ${order.cartId}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Customer Name: ${order.customerName}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Status: ${order.isPaid ? "Paid" : "Pending"}",
              style: TextStyle(
                fontSize: 16,
                color: order.isPaid ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Items:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            order
                    .items
                    .isNotEmpty // ✅ Prevent errors if items are empty
                ? Expanded(
                  child: ListView.builder(
                    itemCount: order.items.length,
                    itemBuilder: (context, index) {
                      final item = order.items[index];
                      return ListTile(
                        title: Text(item.name ?? 'Unknown Item'),
                        subtitle: Text("Quantity: ${item.quantity ?? 1}"),
                        trailing: Text(
                          "\$${(item.price ?? 0).toStringAsFixed(2)}",
                        ),
                      );
                    },
                  ),
                )
                : Text(
                  "No items found",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
            SizedBox(height: 10),
            Text(
              "Total Amount: \$${order.totalAmount.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
