import 'package:demo_app/latest/models/products_model.dart';

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

  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), 'quantity': quantity};
  }
}

class CartModel {
  List<CartItem> cartItems;

  CartModel({this.cartItems = const []});

  // To map the CartModel to/from JSON
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      cartItems:
          (json['cartItems'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'cartItems': cartItems.map((item) => item.toJson()).toList()};
  }
}
