import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

class CategoryTabsWidget extends StatefulWidget {
  final List<String> categories;
  final Function(String) onCategorySelected;

  CategoryTabsWidget({
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  _CategoryTabsWidgetState createState() => _CategoryTabsWidgetState();
}

class _CategoryTabsWidgetState extends State<CategoryTabsWidget> {
  String selectedCategory = "";

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.categories.isNotEmpty ? widget.categories[0] : "";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            widget.categories.map((category) {
              bool isSelected = selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                    widget.onCategorySelected(category);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.color4,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.color5),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.color3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
