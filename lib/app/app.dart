import 'package:flutter/material.dart';

import 'package:pos_coffee_shop/app/app_providers.dart';
import 'package:pos_coffee_shop/app/app_theme.dart';
import 'package:pos_coffee_shop/core/navigation/initial_route_resolver.dart';
import 'package:pos_coffee_shop/core/routes.dart';

class CoffeeShopPOSApp extends StatefulWidget {
  const CoffeeShopPOSApp({super.key});

  @override
  State<CoffeeShopPOSApp> createState() => _CoffeeShopPOSAppState();
}

class _CoffeeShopPOSAppState extends State<CoffeeShopPOSApp> {
  late final Future<String> _initialRouteFuture;

  @override
  void initState() {
    super.initState();
    _initialRouteFuture = InitialRouteResolver.resolve();
  }

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: FutureBuilder<String>(
        future: _initialRouteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Coffee POS',
              theme: AppTheme.lightTheme,
              home: const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Coffee POS',
              theme: AppTheme.lightTheme,
              home: Scaffold(
                body: Center(
                  child: Text(
                    'Gagal memuat aplikasi.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }

          final String initialRoute = snapshot.data ?? AppRoutes.login;

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Coffee POS',
            theme: AppTheme.lightTheme,
            initialRoute: initialRoute,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
