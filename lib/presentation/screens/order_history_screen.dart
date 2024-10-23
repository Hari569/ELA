import 'package:flutter/material.dart';
import '/models/product.dart';
import 'store_screen.dart';
import '../widgets/Cart_Screen.dart';

class Order {
  final String id;
  final DateTime date;
  final List<MapEntry<Product, int>> items;
  final double total;

  Order(
      {required this.id,
      required this.date,
      required this.items,
      required this.total});
}

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<Order> orderHistory = [
    Order(
      id: 'ORD001',
      date: DateTime.now().subtract(const Duration(days: 2)),
      items: [
        MapEntry(
            Product(
                id: '1',
                name: 'Product 1',
                price: 10.0,
                imageUrl: 'https://example.com/image1.jpg'),
            2),
        MapEntry(
            Product(
                id: '2',
                name: 'Product 2',
                price: 15.0,
                imageUrl: 'https://example.com/image2.jpg'),
            1),
      ],
      total: 35.0,
    ),
    Order(
      id: 'ORD002',
      date: DateTime.now().subtract(const Duration(days: 5)),
      items: [
        MapEntry(
            Product(
                id: '3',
                name: 'Product 3',
                price: 20.0,
                imageUrl: 'https://example.com/image3.jpg'),
            1),
      ],
      total: 20.0,
    ),
  ];

  void _addToCart(Product product) {
    // This function would typically update a global cart state
    // For now, we'll just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CartScreen(initialCartItems: [], onRemoveItem: (_) {})),
              );
            },
          ),
        ],
      ),
      body: orderHistory.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_basket,
                      size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text('No orders yet',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Start shopping to see your order history!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => StoreScreen())),
                    child: const Text('START SHOPPING'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                final order = orderHistory[index];
                return ExpansionTile(
                  title: Text('Order ${order.id}'),
                  subtitle: Text(
                      '${order.date.toString().split(' ')[0]} - \$${order.total.toStringAsFixed(2)}'),
                  children: [
                    ...order.items.map((item) => ListTile(
                          leading: Image.network(item.key.imageUrl,
                              width: 50, height: 50, fit: BoxFit.cover),
                          title: Text(item.key.name),
                          subtitle: Text('Quantity: ${item.value}'),
                          trailing: ElevatedButton(
                            onPressed: () => _addToCart(item.key),
                            child: const Text('Add to Cart'),
                          ),
                        )),
                  ],
                );
              },
            ),
    );
  }
}
