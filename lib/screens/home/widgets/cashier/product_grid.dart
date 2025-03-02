import 'package:flutter/material.dart';
import '../../../../models/products_model.dart';
import '../../../../services/product_service.dart';
import '../../../../core/theme.dart';

class ProductGridWidget extends StatelessWidget {
  final String selectedCategory;
  final String searchQuery;

  final Function(Product) onAddToCart;
  final ProductService productService = ProductService();

  ProductGridWidget({
    required this.onAddToCart,
    required this.selectedCategory,
    required this.searchQuery,
  });
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: productService.getProducts(
        searchQuery: searchQuery,
        category: selectedCategory,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Firestore Error: ${snapshot.error}");
          return Center(child: Text("Error loading products!"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print("Firestore Debug: No products available.");
          return Center(child: Text("No products available."));
        }

        List<Product> products = snapshot.data!;

        return Padding(
          padding: EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductCard(product);
            },
          ),
        );
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              product.image,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  product.category,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(height: 5),
                Text(
                  "Rp. ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () => onAddToCart(product),
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.color3,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
