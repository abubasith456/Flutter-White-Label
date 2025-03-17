import 'package:demo_app/latest/components/base/custom_button.dart';
import 'package:demo_app/latest/models/cart_model.dart';
import 'package:demo_app/latest/screens/cart/components/block/cart_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        actions: [
          IconButton(
            icon: Icon(Icons.remove_shopping_cart),
            onPressed: () {
              // context.read<CartBloc>().add(CartEvent.ClearCart());
            },
          ),
        ],
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
                  leading: Image.network(
                    cartItem.product.imageUrl,
                  ), // Assuming Product has imageUrl
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
                              UpdateQuantity(cartItem.product, newQuantity),
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
                            UpdateQuantity(cartItem.product, newQuantity),
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
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 90, // Set a fixed height for the button
              child: CustomButton(
                text: 'Checkout (\$${totalAmount.toStringAsFixed(2)})',
                onPressed: () {
                  // Navigate to checkout screen or perform other actions
                },
                isGradient: true, // Toggle gradient effect
              ),
            ),
          );
        },
      ),
    );
  }
}
