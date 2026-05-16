import 'package:flutter/material.dart';
import '../../../../core/theme.dart';

class CategoryTabsWidget extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryTabsWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  _CategoryTabsWidgetState createState() => _CategoryTabsWidgetState();
}

class _CategoryTabsWidgetState extends State<CategoryTabsWidget> {
  late String selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.selectedCategory; // Sync initial state
  }

  @override
  void didUpdateWidget(CategoryTabsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      setState(() {
        selectedCategory = widget.selectedCategory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? AppColors.primary : AppColors.color4,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isSelected ? AppColors.primary : AppColors.color5,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                        ],
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
      ),
    );
  }
}
