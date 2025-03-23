import 'dart:convert';
import 'package:demo_app/latest/models/api_model/product_model.dart';
import 'package:demo_app/latest/models/cart_model.dart'; // Assuming you have a CartModel class
import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
  static const String _cartKey = "cart";
  final SharedPreferences _prefs;

  CartRepository(this._prefs);

  // ✅ Get all cart items
  Future<List<CartItem>> getAllCartItems() async {
    final jsonString = _prefs.getString(_cartKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final jsonData = jsonDecode(jsonString);

        if (jsonData is List) {
          // ✅ If the stored data is a list, parse it as CartItem list
          return jsonData.map((json) => CartItem.fromJson(json)).toList();
        } else if (jsonData is Map<String, dynamic> &&
            jsonData.containsKey('cartItems')) {
          // 🚨 Old storage format detected (Map instead of List)
          print("Unexpected Map format. Extracting cartItems list.");
          return (jsonData['cartItems'] as List)
              .map((json) => CartItem.fromJson(json))
              .toList();
        } else {
          print("Invalid cart data format.");
        }
      } catch (e, stackTrace) {
        print("Error loading cart data: $e");
        print("Stack trace: $stackTrace");
      }
    }
    return []; // Return an empty list if no cart items exist
  }

  // ✅ Save updated cart to SharedPreferences
  Future<void> saveAllCarts(List<CartItem> cartItems) async {
    final jsonString = jsonEncode(
      cartItems.map((item) => item.toJson()).toList(),
    );
    await _prefs.setString(_cartKey, jsonString);
  }

  // ✅ Add a product to the cart
  Future<void> addCartItem(Product product) async {
    List<CartItem> cartItems = await getAllCartItems();

    int index = cartItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      // If item exists, update its quantity
      cartItems[index] = cartItems[index].copyWith(
        quantity: cartItems[index].quantity + 1,
      );
    } else {
      // If item does not exist, add it
      cartItems.add(CartItem(product: product, quantity: 1));
    }

    await saveAllCarts(cartItems);
  }

  // ✅ Remove a product from the cart
  Future<void> removeProductById(String productId) async {
    List<CartItem> cartItems = await getAllCartItems();
    cartItems.removeWhere((item) => item.product.id == productId);
    await saveAllCarts(cartItems);
  }

  // ✅ Clear the cart
  Future<void> clearAllCarts() async {
    await _prefs.remove(_cartKey);
  }
}
