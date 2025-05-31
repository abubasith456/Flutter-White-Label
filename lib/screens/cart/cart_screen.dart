import 'package:demo_app/components/base/custom_appbar.dart';
import 'package:demo_app/components/base/custom_button.dart';
import 'package:demo_app/components/base/network_image_with_error.dart';
import 'package:demo_app/models/cart_model.dart';
import 'package:demo_app/repository/address_repository.dart';
import 'package:demo_app/screens/address/components/bloc/adress_bloc.dart';
import 'package:demo_app/screens/cart/components/block/cart_block.dart';
import 'package:demo_app/screens/order_confirmation/bloc/order_bloc.dart';
import 'package:demo_app/screens/order_confirmation/order_confirmation_screen.dart';
import 'package:demo_app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    context.read<CartBloc>().add(LoadCart());
    super.initState();
  }

  // Method to print cart details
  void _printCartDetails(List<CartItem> cartItems) {
    if (cartItems.isEmpty) {
      print('Cart is empty');
      return;
    }

    print('===== CHECKOUT DETAILS =====');
    print('Items in cart: ${cartItems.length}');

    double totalAmount = 0;

    for (int i = 0; i < cartItems.length; i++) {
      final item = cartItems[i];
      final itemTotal = item.product.price * item.quantity;
      totalAmount += itemTotal;

      print('Item ${i + 1}: ${item.product.name}');
      print('  - Price: Rs.${item.product.price.toStringAsFixed(2)}');
      print('  - Quantity: ${item.quantity}');
      print('  - Subtotal: Rs.${itemTotal.toStringAsFixed(2)}');
    }

    print('Total Amount: Rs.${totalAmount.toStringAsFixed(2)}');
    print('===========================');

    // Show a snackbar to indicate checkout process
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Proceeding to checkout. Check console for details.'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Cart",
        showActionButton: true,
        actionIcon: Icons.remove_shopping_cart,
        onAction: () {
          context.read<CartBloc>().add(ClearAllCart());
        },
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return Center(child: Text('Your cart is empty.'));
          }

          return ListView.builder(
            itemCount: state.cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = state.cartItems[index];

              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: NetworkImageWithError(
                    imageUrl: cartItem.product.images[0],
                    width: 80,
                    height: 80,
                  ),
                  title: Text(
                    cartItem.product.name,
                  ), // Assuming Product has name
                  subtitle: Text('Price: \$${cartItem.product.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          int newQuantity = cartItem.quantity - 1;
                          if (newQuantity > 0) {
                            context.read<CartBloc>().add(
                              UpdateQuantity(
                                productId: cartItem.product.id,
                                newQuantity: newQuantity,
                              ),
                            );
                          }
                        },
                      ),
                      Text(cartItem.quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          int newQuantity = cartItem.quantity + 1;
                          context.read<CartBloc>().add(
                            UpdateQuantity(
                              productId: cartItem.product.id,
                              newQuantity: newQuantity,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          context.read<CartBloc>().add(
                            RemoveFromCart(cartItem.product),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          double totalAmount = state.cartItems.fold(
            0.0,
            (sum, item) => sum + (item.product.price * item.quantity),
          );
          return Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 55, // Set a fixed height for the button
              child: CustomButton(
                isEnabled: state.cartItems.isNotEmpty,
                text: 'Checkout (\Rs.${totalAmount.toStringAsFixed(2)})',
                onPressed: () {
                  // Navigate to order confirmation screen
                  _navigateToOrderConfirmation(
                    context,
                    state.cartItems,
                    totalAmount,
                  );
                },
                isGradient: true, // Toggle gradient effect
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _navigateToOrderConfirmation(
    BuildContext context,
    List<CartItem> cartItems,
    double totalAmount,
  ) async {
    // Get shared preferences instance for address repository
    final prefs = await SharedPreferences.getInstance();

    // Navigate to order confirmation screen with both blocs
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => sl<OrderBloc>()),
                BlocProvider(
                  create: (context) => AddressBloc(AddressRepository(prefs)),
                ),
              ],
              child: OrderConfirmationScreen(
                cartItems: cartItems,
                totalAmount: totalAmount,
              ),
            ),
      ),
    );
  }
}
