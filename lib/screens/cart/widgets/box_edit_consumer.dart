import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pos_coffee_shop/core/theme.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';

class BoxEditConsumer extends StatefulWidget {
  final String cartId; // Accept cartId

  const BoxEditConsumer({super.key, required this.cartId});

  @override
  _BoxEditConsumerState createState() => _BoxEditConsumerState();
}

class _BoxEditConsumerState extends State<BoxEditConsumer> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    _nameController = TextEditingController(
      text: cartProvider.getConsumerName(widget.cartId),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Center(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.color5,
                prefixIcon: Icon(Icons.person, color: AppColors.color3),
                hintText: "Consumer Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.check_circle,
                    size: 30,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    cartProvider.setConsumerName(
                      widget.cartId,
                      _nameController.text,
                    );
                    cartProvider.notifyListeners();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
