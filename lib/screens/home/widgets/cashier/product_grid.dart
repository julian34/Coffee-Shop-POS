import 'package:flutter/material.dart';
import 'package:pos_coffee_shop/models/cart_model.dart';
import 'package:pos_coffee_shop/untils/format_utils.dart';
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

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 265,
          ),
          padding: EdgeInsets.all(16),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(50, 158, 158, 158),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(125),
                            child: Image.network(
                              product.image,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Text(
                                product.category,
                                style: TextStyle(
                                  color: AppColors.color6,
                                  fontSize: 12,
                                ),
                              ),
                              const Spacer(),
                              SvgCustomApp.getIcon('star', h: 15, w: 15),
                              const SizedBox(width: 4),
                              Text(
                                '4.5',
                                style: TextStyle(
                                  color: AppColors.color6,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(formatCurrency(product.price)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 140, top: 10),
                      child: SvgCustomApp.getIcon('heart'),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Material(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (product.hasMultiplePrices) {
                              _showPriceSelectionDialog(context, product);
                            } else {
                              _addToCart(
                                context,
                                product,
                                product.prices.first,
                              );
                            }
                            // Provider.of<CartProvider>(
                            //   context,
                            //   listen: false,
                            // ).addToCart(
                            //   CartItem(
                            //     productId: product.id,
                            //     name: product.name,
                            //     price: product.price,
                            //     image: product.image,
                            //   ),
                            // );

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text("${product.name} added to cart!"),
                            //     duration: Duration(seconds: 2),
                            //     action: SnackBarAction(
                            //       label: "Undo",
                            //       onPressed: () {
                            //         final cart = Provider.of<CartProvider>(
                            //           context,
                            //           listen: false,
                            //         );
                            //         // var item =
                            //         //     cart.items.values.toList()[index];
                            //         // cart.updateQuantity(
                            //         //   product.id,
                            //         //   (item.quantity - 1).toInt(),
                            //         // );
                            //         // Provider.of<CartProvider>(
                            //         //   context,
                            //         //   listen: false,
                            //         // ).updateQuantity(product.id, 0);
                            //         // cartProvider.updateQuantity(cartId, product.id, 0);
                            //       },
                            //     ),
                            //   ),
                            // );
                          },
                          icon: SvgCustomApp.getIcon(
                            'add',
                            c: AppColors.color5,
                          ),
                        ),
                        // child: InkWell(
                        //   child: Padding(
                        //     padding: EdgeInsets.all(8),
                        //     child:
                        //   ),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        // return Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: SizedBox(
        //     height:
        //         MediaQuery.of(context).size.height * 0.7, // Set a fixed height
        //     child: GridView.builder(
        //       physics: BouncingScrollPhysics(),
        //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 2,
        //         childAspectRatio: 0.75,
        //         crossAxisSpacing: 10,
        //         mainAxisSpacing: 10,
        //       ),
        //       itemCount: products.length,
        //       itemBuilder: (context, index) {
        //         final product = products[index];
        //         return _buildProductCard(context, product);
        //       },
        //     ),
        //   ),
        // );
      },
    );
  }
}

void _addToCart(
  BuildContext context,
  Product product,
  ProductPrice selectedPrice,
) {
  final cartProvider = Provider.of<CartProvider>(context, listen: false);

  final uniqueKey = '${product.id}-${selectedPrice.label}';

  final existingItem = cartProvider.items.values.firstWhere(
    (item) => item.productId == product.id && item.label == selectedPrice.label,
    orElse:
        () => CartItem(
          productId: '',
          name: '',
          price: 0,
          quantity: 0,
          label: '',
          image: '',
          selectedPrice: ProductPrice(label: '', amount: 0),
        ),
  );
  print("tes uplaod ${existingItem.label}");
  if (existingItem != null) {
    print("existing ${existingItem.label}");
    cartProvider.updateQuantity(
      existingItem.productId,
      existingItem.quantity + 1,
    );
  } else {
    print("new ${existingItem.label}");
    cartProvider.addToCart(
      CartItem(
        productId: product.id,
        name: '${product.name} (${selectedPrice.label})',
        price: selectedPrice.amount,
        selectedPrice: selectedPrice,
        label: selectedPrice.label,
        image: product.image,
        quantity: 1, // Ensure to set quantity for new items
      ),
    );
  }

  // Provider.of<CartProvider>(context, listen: false).addToCart(
  //   CartItem(
  //     productId: product.id,
  //     name: '${product.name} (${selectedPrice.label})',
  //     price: selectedPrice.amount,
  //     selectedPrice: selectedPrice,
  //     label: selectedPrice.label,
  //     image: product.image,
  //   ),
  // );

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("${product.name} (${selectedPrice.label}) added to cart!"),
      duration: const Duration(seconds: 2),
    ),
  );
}

void _showPriceSelectionDialog(BuildContext context, Product product) {
  showModalBottomSheet(
    context: context,
    builder: (contex) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Select Price for ${product.name}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ...product.prices.map((priceOption) {
              print(priceOption.label);
              return ListTile(
                title: Text(
                  '${priceOption.label} - ${formatCurrency(priceOption.amount)}',
                ),
                onTap: () {
                  Navigator.pop(context);
                  _addToCart(context, product, priceOption);
                },
              );
            }).toList(),
          ],
        ),
      );
    },
  );
}
