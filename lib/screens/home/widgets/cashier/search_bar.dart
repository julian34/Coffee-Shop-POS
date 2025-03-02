import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch; // Declare onSearch as a required parameter

  const SearchBarWidget({
    super.key,
    required this.onSearch,
  }); // Accept it in the constructor

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged:
                  widget.onSearch, // Call onSearch from the parent widget
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.color5,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: SvgCustomApp.getIcon('search', h: 20),
                ),
                prefixIconConstraints: BoxConstraints(
                  maxWidth: 50,
                  maxHeight: 50,
                ),
                hintText: "Search",
                hintStyle: TextStyle(color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: SvgCustomApp.getIcon("filter", c: AppColors.color5),
            ),
          ),
        ],
      ),
    );
  }
}
