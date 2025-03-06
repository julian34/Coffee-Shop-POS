import 'package:flutter/material.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.cart);
        },
        shape: const CircleBorder(),
        backgroundColor: AppColors.color3,
        foregroundColor: AppColors.color4,
        child: SvgCustomApp.getIcon('money-bill-wave', c: AppColors.color5),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
