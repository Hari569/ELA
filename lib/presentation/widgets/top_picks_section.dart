import 'package:flutter/material.dart';
import '/models/product.dart';
import 'package:ELA/presentation/screens/Product_Detail_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TopPicksSection extends StatefulWidget {
  final Function(Product) onAddToCart;

  const TopPicksSection({Key? key, required this.onAddToCart})
      : super(key: key);

  @override
  _TopPicksSectionState createState() => _TopPicksSectionState();
}

class _TopPicksSectionState extends State<TopPicksSection> {
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
    List<Product> topPicks = [
      Product(
          id: '8',
          name: 'Rubber Plant',
          price: 29.99,
          imageUrl: 'https://via.placeholder.com/150'),
      Product(
          id: '9',
          name: 'Peace Lily',
          price: 22.99,
          imageUrl: 'https://via.placeholder.com/150'),
      Product(
          id: '10',
          name: 'Aloe Vera',
          price: 18.99,
          imageUrl: 'https://via.placeholder.com/150'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Top Picks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: topPicks.length,
            itemBuilder: (context, index) {
              final product = topPicks[index];
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
                child: _buildTopPickCard(product),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopPickCard(Product product) {
    final isShortlisted = shortlistedProductIds.contains(product.id);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 160,
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
                        isShortlisted ? Icons.favorite : Icons.favorite_border,
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
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('\₹${product.price.toStringAsFixed(2)}'),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () => widget.onAddToCart(product),
                    child: const Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 36),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
