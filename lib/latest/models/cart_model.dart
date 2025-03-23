import 'package:demo_app/latest/models/api_model/product_model.dart';
import 'dart:math';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // To map the CartItem to/from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), 'quantity': quantity};
  }
}

class CartModel {
  final String cartId;
  List<CartItem> cartItems;

  CartModel({String? cartId, this.cartItems = const []})
    : cartId = cartId ?? _generateCartId();

  // Generate a unique cart ID
  static String _generateCartId() {
    final random = Random();
    return DateTime.now().millisecondsSinceEpoch.toString() +
        random.nextInt(99999).toString();
  }

  // Convert JSON to CartModel
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartId: json['cartId'] ?? _generateCartId(),
      cartItems:
          (json['cartItems'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList(),
    );
  }

  // Convert CartModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'cartItems': cartItems.map((item) => item.toJson()).toList(),
    };
  }
}
