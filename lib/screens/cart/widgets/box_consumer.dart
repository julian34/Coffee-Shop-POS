import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';

class BoxConsumer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, provider, child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10.5, vertical: 5),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: AppColors.primary),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.person, color: AppColors.primary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Consumer name',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.color3,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  icon: Icon(Icons.edit, color: AppColors.color5),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
