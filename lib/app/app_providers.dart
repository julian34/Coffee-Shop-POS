import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pos_coffee_shop/providers/auth_provider.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';
import 'package:pos_coffee_shop/providers/orders_provider.dart';
import 'package:pos_coffee_shop/providers/payment_provider.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
        ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()),
        ChangeNotifierProvider<PaymentProvider>(
          create: (_) => PaymentProvider(),
        ),
      ],
      child: child,
    );
  }
}
