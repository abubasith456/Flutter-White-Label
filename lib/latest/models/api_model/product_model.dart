import 'package:demo_app/latest/models/api_model/category_model.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final Category category;
  final int stock;
  final List<ProductSize> sizes;
  final List<String> images;
  final String? offerId;
  final String createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.stock,
    required this.sizes,
    required this.images,
    this.offerId,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: Category.fromJson(json['category'] ?? {}),
      stock: json['stock'] ?? 0,
      sizes:
          (json['sizes'] as List<dynamic>?)
              ?.map((size) => ProductSize.fromJson(size))
              .toList() ??
          [],
      images: List<String>.from(
        (json['images'] as List<dynamic>?)?.isEmpty ?? true
            ? [
              "https://karanzi.websites.co.in/obaju-turquoise/img/product-placeholder.png",
            ]
            : json['images'] ??
                [
                  "https://karanzi.websites.co.in/obaju-turquoise/img/product-placeholder.png",
                ],
      ),
      offerId: json['offerId'],
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category.toJson(),
      'stock': stock,
      'sizes': sizes.map((size) => size.toJson()).toList(),
      'images': images,
      'offerId': offerId,
      'createdAt': createdAt,
    };
  }
}

class ProductSize {
  final String label;
  final double price;
  final int stock;
  final String id;

  ProductSize({
    required this.label,
    required this.price,
    required this.stock,
    required this.id,
  });

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      label: json['label'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'label': label, 'price': price, 'stock': stock, '_id': id};
  }
}
