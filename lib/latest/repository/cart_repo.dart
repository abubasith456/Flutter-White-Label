import 'dart:convert';
import 'package:demo_app/latest/models/cart_model.dart'; // Assuming you have a CartModel class
import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
  static const String _cartKey =
      "cart"; // Key to store cart data in SharedPreferences
  final SharedPreferences _prefs; // Store the instance of SharedPreferences

  CartRepository(this._prefs);

  // Method to retrieve the cart from SharedPreferences
  Future<List<CartModel>> getCart() async {
    final data = _prefs.getString(_cartKey); // Get stored cart data
    if (data == null) {
      return []; // If no cart data is found, return an empty list
    }

    // Decode the JSON string into a List of CartModel
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => CartModel.fromJson(json)).toList();
  }

  // Method to save the cart to SharedPreferences
  Future<void> saveCart(List<CartModel> cart) async {
    try {
      final jsonList =
          cart
              .map((cartItem) => cartItem.toJson())
              .toList(); // Convert cart items to JSON
      final jsonString = jsonEncode(
        jsonList,
      ); // Convert the list of cart items into a JSON string
      await _prefs.setString(
        _cartKey,
        jsonString,
      ); // Save the cart data in SharedPreferences
    } catch (e, stackTrace) {
      print("Error saving cart data: $e");
      print("Stack trace: $stackTrace");
    }
  }

  // Method to clear the cart data from SharedPreferences
  Future<void> clearCart() async {
    await _prefs.remove(
      _cartKey,
    ); // Remove the cart data stored in SharedPreferences
  }
}
