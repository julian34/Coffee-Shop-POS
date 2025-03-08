import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:pos_coffee_shop/models/order_model.dart';
import 'package:pos_coffee_shop/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import 'widgets/cashier/cashier_app_bar.dart';
import 'widgets/cashier/search_bar.dart';
import 'widgets/cashier/category_tabs.dart';
import 'widgets/cashier/product_grid.dart';
import 'widgets/cashier/bottom_nav_bar.dart';
import '../../core/routes.dart';

class CashierHomeScreen extends StatefulWidget {
  const CashierHomeScreen({super.key});

  @override
  _CashierHomeWidgetState createState() => _CashierHomeWidgetState();
}

class _CashierHomeWidgetState extends State<CashierHomeScreen> {
  String searchQuery = "";
  String selectedCategory = "All";
  List<String> categories = ["All", "Coffee", "Non Coffee", "Snacks"];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: const CashierAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 60), // Prevent FAB overlap
        child: ListView(
          children: [
            SearchBarWidget(
              onSearch: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
            CategoryTabsWidget(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),
            ProductGridWidget(
              selectedCategory: selectedCategory,
              searchQuery: searchQuery,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              final cartProvider = Provider.of<CartProvider>(
                context,
                listen: false,
              );
              final order = OrderList(
                cartId: "",
                customerName: "Guest",
                totalAmount: 0.0,
                isPaid: false,
                paymentMode: "Cash",
                status: "Pending",
                createdAt: DateTime.now(),
                items: cartProvider.items.values.toList(),
              );

              Navigator.pushNamed(context, AppRoutes.cart, arguments: order);
            },
            shape: const CircleBorder(),
            backgroundColor: AppColors.color3,
            foregroundColor: AppColors.color4,
            // child: SvgCustomApp.getIcon('money-bill-wave', c: AppColors.color5),
            child: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return Stack(
                  children: [
                    SvgCustomApp.getIcon(
                      'money-bill-wave',
                      c: AppColors.color5,
                    ),
                    if (cartProvider.items.isNotEmpty)
                      Positioned(
                        width: 15,
                        right: 2,
                        // top: 8,
                        bottom: 0,
                        // top: -,
                        child: badges.Badge(
                          badgeContent: Text(
                            cartProvider.items.length.toString(),
                            style: TextStyle(
                              color: AppColors.color5,
                              fontSize: 8,
                            ),
                          ),
                          badgeStyle: badges.BadgeStyle(
                            badgeColor: AppColors.color6,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
