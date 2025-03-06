import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/core/theme.dart';

class Itemcard extends StatelessWidget {
  final dynamic item;
  const Itemcard({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance
              .collection('products')
              .doc(item.productId)
              .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return SizedBox();
        }
        var productData = snapshot.data!.data() as Map<String, dynamic>;
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.color3,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(productData['image']),
                    radius: 24,
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(color: AppColors.primary),
                      ),
                      Text(
                        "Rp. ${item.price}",
                        style: TextStyle(color: AppColors.color5),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.remove, color: AppColors.color5),
                  ),
                  Text(
                    "${item.quantity}",
                    style: TextStyle(color: AppColors.color5),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add, color: AppColors.color5),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
