import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';
import 'package:pos_coffee_shop/untils/format_utils.dart';
import 'package:provider/provider.dart';

class Itemcard extends StatelessWidget {
  final dynamic item;
  const Itemcard({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.color3,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(item.image),
                      radius: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            '${item.name}',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            // minFontSize: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            formatCurrency(item.price * item.quantity),
                            style: TextStyle(color: AppColors.color5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      cart.updateQuantity(item.uniqueKey, item.quantity - 1);
                    },
                    icon: Icon(Icons.remove, color: AppColors.color5),
                  ),
                  Text(
                    "${item.quantity}",
                    style: TextStyle(color: AppColors.color5),
                  ),
                  IconButton(
                    onPressed: () {
                      cart.updateQuantity(item.uniqueKey, item.quantity + 1);
                    },
                    icon: Icon(Icons.add, color: AppColors.color5),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
