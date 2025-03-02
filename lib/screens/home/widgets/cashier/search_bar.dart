import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';

class SearchBarWidget extends StatefulWidget {
  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState(
    onSearch: (query) {
      print("search $query");
    },
  );
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final Function(String) onSearch;
  _SearchBarWidgetState({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onSearch,
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
                // prefixIcon: Icon(Icons.search, color: AppColors.color2),
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
