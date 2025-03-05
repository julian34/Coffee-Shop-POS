import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';

class OrderSummaryTab extends StatelessWidget {
  final String cartId;

  const OrderSummaryTab({super.key, required this.cartId});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(
      context,
    ); // ✅ Listen for updates

    // ✅ Get cart items & total count
    final items = cartProvider.getItems(cartId);
    final totalItems = items.fold(0, (sum, item) => sum + item.quantity);

    // ✅ Calculate totals
    double itemTotal = cartProvider.getTotalPrice(cartId);
    double discount = itemTotal * 0.1; // Example: 10% discount
    double tax = (itemTotal - discount) * 0.08; // Example: 8% tax
    double total = itemTotal - discount + tax;

    // 🛠️ Debugging
    print("🛠️ Debug: OrderSummaryTab - cartId: $cartId");
    print("🛠️ Debug: Total Items: $totalItems");
    print("🛠️ Debug: Cart Items: $items");

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.color2,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          Divider(color: AppColors.primary),
          _buildSummaryRow(
            "Total Items",
            totalItems.toDouble(),
          ), // Show total items
          _buildSummaryRow("Item total", itemTotal),
          _buildSummaryRow("Discount (10%)", -discount),
          _buildSummaryRow("Tax (8%)", tax),
          Divider(color: AppColors.primary),
          _buildSummaryRow("Total", total, isBold: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, double value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 12 : 12,
            ),
          ),
          Text(
            "Rp. ${value.toStringAsFixed(2)}",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 12 : 12,
            ),
          ),
        ],
      ),
    );
  }
}
