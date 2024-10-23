import 'package:flutter/material.dart';
import '/models/product.dart';
import 'package:ELA/presentation/screens/Product_Detail_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FeaturedPlantsGrid extends StatefulWidget {
  final Function(Product) onAddToCart;

  const FeaturedPlantsGrid({Key? key, required this.onAddToCart})
      : super(key: key);

  @override
  _FeaturedPlantsGridState createState() => _FeaturedPlantsGridState();
}

class _FeaturedPlantsGridState extends State<FeaturedPlantsGrid> {
  List<String> shortlistedProductIds = [];

  @override
  void initState() {
    super.initState();
    _loadShortlistedProducts();
  }

  Future<void> _loadShortlistedProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getStringList('shortlisted_products') ?? [];
    setState(() {
      shortlistedProductIds = productsJson
          .map((json) => Product.fromJson(jsonDecode(json)).id)
          .toList();
    });
  }

  Future<void> _toggleShortlist(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = prefs.getStringList('shortlisted_products') ?? [];
    List<Product> shortlistedProducts =
        productsJson.map((json) => Product.fromJson(jsonDecode(json))).toList();

    if (shortlistedProductIds.contains(product.id)) {
      shortlistedProducts.removeWhere((p) => p.id == product.id);
      shortlistedProductIds.remove(product.id);
    } else {
      shortlistedProducts.add(product);
      shortlistedProductIds.add(product.id);
    }

    final updatedProductsJson = shortlistedProducts
        .map((product) => jsonEncode(product.toJson()))
        .toList();
    await prefs.setStringList('shortlisted_products', updatedProductsJson);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Product> featuredProducts = [
      Product(
          id: '1',
          name: 'Monstera Deliciosa',
          price: 29.99,
          imageUrl: 'https://via.placeholder.com/150'),
      Product(
          id: '2',
          name: 'Snake Plant',
          price: 19.99,
          imageUrl: 'https://via.placeholder.com/150'),
      Product(
          id: '3',
          name: 'Fiddle Leaf Fig',
          price: 39.99,
          imageUrl: 'https://via.placeholder.com/150'),
      Product(
          id: '4',
          name: 'Pothos',
          price: 15.99,
          imageUrl: 'https://via.placeholder.com/150'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Featured Plants',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: featuredProducts.length,
          itemBuilder: (context, index) {
            final product = featuredProducts[index];
            final isShortlisted = shortlistedProductIds.contains(product.id);
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(
                      product: product,
                      onAddToCart: widget.onAddToCart,
                    ),
                  ),
                );
              },
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: IconButton(
                              icon: Icon(
                                isShortlisted
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isShortlisted ? Colors.red : null,
                              ),
                              onPressed: () => _toggleShortlist(product),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('\₹${product.price.toStringAsFixed(2)}'),
                          const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => widget.onAddToCart(product),
                              child: const Text('Add to Cart'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
