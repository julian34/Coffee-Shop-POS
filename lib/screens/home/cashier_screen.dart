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
  String searchQuery = "";
  String selectedCategory = "All";
  List<String> categories = ["All", "Coffee", "Non Coffee", "Snacks"];

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
          Expanded(
            child: ProductGridWidget(
              onAddToCart: (product) {
                print("Added to cart: ${product.name}");
              },
              selectedCategory: selectedCategory,
              searchQuery: searchQuery,
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
