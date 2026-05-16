import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/providers/auth_provider.dart';
import '../../core/theme.dart';
import 'models/cashier/appbarselected.dart';

class ManagerHomeScreen extends StatelessWidget {
  const ManagerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color5,
      appBar: AppBar(
        backgroundColor: AppColors.color3,
        toolbarHeight: 100,
        leadingWidth: 152,
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgCustomApp.getIcon("user"),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Username",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.color2,
                          ),
                        ),
                        Text(
                          "Role",
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.color2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgCustomApp.getIcon("marker", c: AppColors.color2),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Coffee Shop name",
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.color2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: PopupMenuButton<int>(
                  icon: SvgCustomApp.getIcon('menu-burger', h: 30),
                  color: AppColors.primary,
                  onSelected:
                      (item) => AppBarSelectItem(context, item, AuthProvider()),
                  itemBuilder:
                      (context) => [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              color: AppColors.color2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        PopupMenuDivider(),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: AppColors.color2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                ),
              ),
            ],
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(150),
            bottomRight: Radius.circular(150),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: SizedBox(),
        ),
      ),
      body: Column(
        children: [
          // _buildHeader(),
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
        backgroundColor: AppColors.color3,
        foregroundColor: AppColors.color4,
        elevation: 0,
        child: SvgCustomApp.getIcon(
          'money-bill-wave',
          c: AppColors.color2,
          h: 30,
          w: 30,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5.0,
        shape: CircularNotchedRectangle(),
        color: AppColors.color3,
        child: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(padding: EdgeInsets.all(16.0));
  }

  Widget _buildCategoryTabs() {
    return Row();
  }

  Widget _buildProductGrid() {
    return Padding(padding: EdgeInsets.all(16.0));
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
