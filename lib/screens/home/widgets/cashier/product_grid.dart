import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/models/cart_model.dart';
import 'package:provider/provider.dart';
import '../../../../models/products_model.dart';
import '../../../../services/product_service.dart';
import '../../../../providers/cart_provider.dart';
import '../../../../core/theme.dart';

class ProductGridWidget extends StatelessWidget {
  final String selectedCategory;
  final String searchQuery;
  final ProductService productService = ProductService();

  ProductGridWidget({
    super.key,
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
          debugPrint("Firestore Error: ${snapshot.error}");
          return Center(child: Text("Error loading products!"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          debugPrint("Firestore Debug: No products available.");
          return Center(child: Text("No products available."));
        }

        List<Product> products = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height:
                MediaQuery.of(context).size.height * 0.7, // Set a fixed height
            child: GridView.builder(
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(context, product);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
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
              errorBuilder:
                  (context, error, stackTrace) =>
                      Icon(Icons.broken_image, size: 100, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
          IconButton(
            icon: SvgCustomApp.getIcon("add"),
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).addToCart(
                CartItem(
                  productId: product.id,
                  name: product.name,
                  price: product.price,
                  image: product.image,
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("${product.name} added to cart!"),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      // cartProvider.updateQuantity(cartId, product.id, 0);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
