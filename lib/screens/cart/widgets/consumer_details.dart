import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/screens/cart/widgets/box_edit_consumer.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';

class ConsumerDetailsTab extends StatefulWidget {
  const ConsumerDetailsTab({super.key});

  @override
  _ConsumerDetailsWidgetState createState() => _ConsumerDetailsWidgetState();
}

class _ConsumerDetailsWidgetState extends State<ConsumerDetailsTab> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, provider, child) {
        return provider.isEditingCN
            ? BoxEditConsumer()
            : Container(
              margin: EdgeInsets.symmetric(horizontal: 10.5, vertical: 5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: AppColors.primary),
                // color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgCustomApp.getIcon('user'),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Consumer Name \n -------------------- ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    // width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.color3,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Consumer<CartProvider>(
                      builder: (context, provider, child) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.color3,
                          ),
                          onPressed: provider.showtEditingCN,
                          child: Center(
                            child: SvgCustomApp.getIcon(
                              'pen-field',
                              c: AppColors.color5,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
      },
    );
  }
}
