import 'package:flutter/material.dart';
import '/models/product.dart';
import 'Checkout_Screen.dart';

class CartScreen extends StatefulWidget {
  final List<Product> initialCartItems;
  final Function(Product) onRemoveItem;

  const CartScreen({
    Key? key,
    required this.initialCartItems,
    required this.onRemoveItem,
  }) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<MapEntry<Product, int>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems =
        widget.initialCartItems.map((item) => MapEntry(item, 1)).toList();
  }

  double get total =>
      cartItems.fold(0, (sum, item) => sum + (item.key.price * item.value));

  void _updateQuantity(int index, int delta) {
    setState(() {
      int newQuantity = cartItems[index].value + delta;
      if (newQuantity > 0) {
        cartItems[index] = MapEntry(cartItems[index].key, newQuantity);
      } else {
        _removeItem(index);
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      widget.onRemoveItem(cartItems[index].key);
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Your cart is empty'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Start Shopping'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index].key;
                      final quantity = cartItems[index].value;
                      return ListTile(
                        leading: Image.network(item.imageUrl,
                            width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(item.name),
                        subtitle: Text(
                            '\$${(item.price * quantity).toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _updateQuantity(index, -1),
                            ),
                            Text('$quantity'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _updateQuantity(index, 1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _removeItem(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('\$${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    child: const Text('Checkout'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () => _showCheckoutDialog(context),
                  ),
                ),
              ],
            ),
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Checkout'),
          content: const Text('Proceed to payment?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Proceed'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(
                      cartItems: cartItems
                          .expand((item) => List.filled(item.value, item.key))
                          .toList(),
                      total: total,
                    ),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing payment...')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
