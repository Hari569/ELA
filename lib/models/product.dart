import 'dart:convert';

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final List<String>? imageUrls;
  final String? description;
  bool isAvailable;
  bool hasOffer;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.imageUrls,
    this.description,
    this.isAvailable = false,
    this.hasOffer = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'description': description,
      'isAvailable': isAvailable,
      'hasOffer': hasOffer,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      imageUrls: json['imageUrls'] != null
          ? List<String>.from(json['imageUrls'])
          : null,
      description: json['description'],
      isAvailable: json['isAvailable'] ?? false,
      hasOffer: json['hasOffer'] ?? false,
    );
  }

  static String encode(List<Product> products) =>
      json.encode(products.map((product) => product.toJson()).toList());

  static List<Product> decode(String productsString) =>
      (json.decode(productsString) as List<dynamic>)
          .map<Product>((item) => Product.fromJson(item))
          .toList();
}
