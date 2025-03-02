import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'widgets/cashier/cashier_app_bar.dart';
import 'widgets/cashier/search_bar.dart';
import 'widgets/cashier/category_tabs.dart';
import 'widgets/cashier/product_grid.dart';
import 'widgets/cashier/bottom_nav_bar.dart';

class CashierHomeScreen extends StatefulWidget {
  @override
  _CashierHomeWidgetState createState() => _CashierHomeWidgetState();
}

class _CashierHomeWidgetState extends State<CashierHomeScreen> {
  final List<String> categories = ["all", "Non Coffee", "Coffee", "Snacks"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: CashierAppBar(),
      ),
      body: Column(
        children: [
          SearchBarWidget(),
          CategoryTabsWidget(
            categories: categories,
            onCategorySelected: (category) {
              print("Selected Category: $category");
            },
          ),
          Expanded(
            child: ProductGridWidget(
              onAddToCart: (product) {
                print("Added to cart: ${product.name}");
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        child: SvgCustomApp.getIcon('money-bill-wave', c: AppColors.color5),
        backgroundColor: AppColors.color3,
        foregroundColor: AppColors.color4,
        // elevation: 0,
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
