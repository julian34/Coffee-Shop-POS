import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:provider/provider.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';

class ConsumerDetailsTab extends StatelessWidget {
  final TextEditingController controller;
  // final Function(String) onChanged;
  const ConsumerDetailsTab({
    super.key,
    required this.controller,
    // required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            controller: controller,
            // onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.color5,
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 15),
                child: SvgCustomApp.getIcon('user'),
              ),
              hintText: "Customer Name",
              hintStyle: TextStyle(color: AppColors.primary),
              prefixIconConstraints: BoxConstraints(
                maxHeight: 50,
                maxWidth: 50,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
        // BoxEditConsumer()
        // TextField();
      },
    );
  }
}
