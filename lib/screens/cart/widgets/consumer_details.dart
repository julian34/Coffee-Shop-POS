import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';

class ConsumerDetailsTab extends StatefulWidget {
  const ConsumerDetailsTab({super.key});

  @override
  _ConsumerDetailsWidgetState createState() => _ConsumerDetailsWidgetState();
}

class _ConsumerDetailsWidgetState extends State<ConsumerDetailsTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.5, vertical: 5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: AppColors.primary),
        // color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgCustomApp.getIcon('user'),
              SizedBox(width: 8),
              Text(
                "Consumer Name \n -------------------- ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            width: 80,
            decoration: BoxDecoration(
              color: AppColors.color3,
              borderRadius: BorderRadius.circular(30),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.color3,
              ),
              onPressed: () {},
              child: Center(
                child: SvgCustomApp.getIcon('pen-field', c: AppColors.color5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
