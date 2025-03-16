import 'package:demo_app/latest/models/cart_model.dart';
import 'package:demo_app/latest/repository/cart_repo.dart';
import 'package:demo_app/latest/services/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Bloc Events
abstract class CartEvent {}

class AddToCart extends CartEvent {
  final Product product;
  AddToCart(this.product);
}

class RemoveFromCart extends CartEvent {
  final Product product;
  RemoveFromCart(this.product);
}

class UpdateQuantity extends CartEvent {
  final Product product;
  final int quantity;
  UpdateQuantity(this.product, this.quantity);
}

class LoadCart extends CartEvent {}

// Bloc State
class CartState {
  final List<CartItem> cartItems;
  CartState(this.cartItems);
}

// Bloc Implementation
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository = sl<CartRepository>();

  CartBloc() : super(CartState([])) {
    on<AddToCart>((event, emit) {
      // Add item to cart
      final cartItem = CartItem(
        product: event.product,
        quantity: 1,
      ); // Default quantity is 1
      final updatedCart = List<CartItem>.from(state.cartItems)..add(cartItem);
      emit(CartState(updatedCart));
    });

    on<RemoveFromCart>((event, emit) {
      // Remove item from cart
      final updatedCart =
          state.cartItems
              .where((item) => item.product.id != event.product.id)
              .toList();
      emit(CartState(updatedCart));
    });

    on<UpdateQuantity>((event, emit) {
      // Update item quantity in the cart
      final updatedCart =
          state.cartItems.map((item) {
            if (item.product.id == event.product.id) {
              item.quantity = event.quantity;
            }
            return item;
          }).toList();
      emit(CartState(updatedCart));
    });

    on<LoadCart>((event, emit) async {
      print("CART CALLED: LoadCart");
      // Load cart data from repository (returns List<CartModel>)
      final cartModels = await _cartRepository.getCart();

      // Flatten the cart models to CartItems (cartItems is already a List<CartItem>)
      final cartItems =
          cartModels.expand((cartModel) => cartModel.cartItems).toList();
      print("CART CALLED: ${cartItems}");
      // Emit the cart state with the updated cartItems
      emit(CartState(cartItems));
    });
  }
}
