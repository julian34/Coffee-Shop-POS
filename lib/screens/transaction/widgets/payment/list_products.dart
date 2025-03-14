import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/models/cart_model.dart';
import 'package:pos_coffee_shop/untils/format_utils.dart';

class ListProducts extends StatelessWidget {
  final List<CartItem> orderItems;

  const ListProducts({super.key, required this.orderItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orderItems.length,
      itemBuilder: (context, index) {
        final item = orderItems[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(item.image),
                radius: 24,
              ),
              SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Divider(),
                    Text(
                      '${formatCurrency(item.price)} x ${item.quantity} = ${formatCurrency(item.price * item.quantity)}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
