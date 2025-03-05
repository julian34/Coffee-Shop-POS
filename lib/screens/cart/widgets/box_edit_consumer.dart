import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';

class BoxEditConsumer extends StatelessWidget {
  late TextEditingController _nameContorler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              controller: _nameContorler,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.color5,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(15),
                  child: SvgCustomApp.getIcon('user', c: AppColors.color3),
                ),
                hintText: "Consumer Name",
                // hintStyle: TextStyle(color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  onPressed: () {
                    cartProvider.submitEditingCN();
                  },
                  icon: SvgCustomApp.getIcon('check-circle', h: 50),
                ),
                suffixIconConstraints: BoxConstraints(
                  maxHeight: 50,
                  maxWidth: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
