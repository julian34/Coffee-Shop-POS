import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';

class CashierHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color5,
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildCategoryTabs(),
          Expanded(child: _buildProductGrid()),
          // _buildBottomNavBar(),
        ],
      ),
      //navbar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        child: SvgCustomApp.getIcon(
          'money-bill-wave',
          c: AppColors.color2,
          h: 30,
          w: 30,
        ),
        backgroundColor: AppColors.color3,
        foregroundColor: AppColors.color4,
        elevation: 0,
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5.0,
        shape: CircularNotchedRectangle(),
        color: AppColors.color3,
        child: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hansen Leo",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Cashiers",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    "Sastra Coffee Shop",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              Icon(Icons.menu, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(padding: EdgeInsets.all(16.0));
  }

  Widget _buildCategoryTabs() {
    return Row();
  }

  Widget _buildCategoryButton(String title) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 8.0));
  }

  Widget _buildProductGrid() {
    List<Map<String, String>> products = [];
    return Padding(padding: EdgeInsets.all(16.0));
  }

  Widget _buildProductCard(Map<String, String> product) {
    return Card();
  }

  Widget _buildBottomNavBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgCustomApp.getIcon('home'),
              Text("Home", style: AppFonts.navBarText),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgCustomApp.getIcon('receipt', c: AppColors.color4),
              Text("Order List", style: AppFonts.navBarText),
            ],
          ),
        ),
      ],
    );
  }
}
