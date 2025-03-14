import 'package:flutter/material.dart';

class CategoryTabWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const CategoryTabWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilterButton(
          label: "Pending",
          isSelected: selectedFilter == "Pending",
          onTap: () {
            onFilterChanged("Pending");
          },
        ),
        SizedBox(width: 10),
        FilterButton(
          label: "Paid",
          isSelected: selectedFilter == "Paid",
          onTap: () {
            onFilterChanged("Paid");
          },
        ),
        SizedBox(width: 10),
        FilterButton(
          label: "All",
          isSelected: selectedFilter == "All",
          onTap: () {
            onFilterChanged("All");
          },
        ),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.brown : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.4),
                      blurRadius: 10,
                    ),
                  ]
                  : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

//   final List<String> categories;
//   final String selectedCategory;
//   final Function(String) onCategorySelected;

//   const CategoryTabWidget({
//     super.key,
//     required this.categories,
//     required this.selectedCategory,
//     required this.onCategorySelected,
//   });

//   @override
//   _CategoryTabWidgetState createState() => _CategoryTabWidgetState();
// }

// class _CategoryTabWidgetState extends State<CategoryTabWidget> {
//   late String selectedCategory;

//   @override
//   void initState() {
//     super.initState();
//     selectedCategory = widget.selectedCategory; // Sync initial state
//   }

//   @override
//   void didUpdateWidget(CategoryTabWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.selectedCategory != widget.selectedCategory) {
//       setState(() {
//         selectedCategory = widget.selectedCategory;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children:
//               widget.categories.map((category) {
//                 bool isSelected = selectedCategory == category;
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selectedCategory = category;
//                       });
//                       widget.onCategorySelected(category);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 15,
//                         vertical: 10,
//                       ),
//                       decoration: BoxDecoration(
//                         color:
//                             isSelected ? AppColors.primary : AppColors.color4,
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(
//                           color:
//                               isSelected ? AppColors.primary : AppColors.color5,
//                         ),
//                         boxShadow: [
//                           if (isSelected)
//                             BoxShadow(
//                               color: AppColors.primary.withOpacity(0.3),
//                               blurRadius: 8,
//                               spreadRadius: 2,
//                             ),
//                         ],
//                       ),
//                       child: Text(
//                         category,
//                         style: TextStyle(
//                           color: AppColors.color3,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//         ),
//       ),
//     );
//   }
// }
