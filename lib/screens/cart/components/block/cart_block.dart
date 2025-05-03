import 'package:demo_app/models/api_model/product_model.dart';
import 'package:demo_app/models/cart_model.dart';
import 'package:demo_app/repository/cart_repo.dart';
import 'package:demo_app/services/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Bloc Events
abstract class CartEvent {}

class AddToCart extends CartEvent {
  final Product product;
  final String? selectedSize;

  AddToCart(this.product, {this.selectedSize});
}

class RemoveFromCart extends CartEvent {
  final Product product;
  RemoveFromCart(this.product);
}

class UpdateQuantity extends CartEvent {
  final String productId;
  final int newQuantity;

  UpdateQuantity({required this.productId, required this.newQuantity});
}

class LoadCart extends CartEvent {}

class ClearAllCart extends CartEvent {}

// Bloc State with cart count
class CartState extends Equatable {
  final List<CartItem> cartItems;
  final int cartCount;

  CartState(this.cartItems)
    : cartCount = cartItems.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({List<CartItem>? cartItems}) {
    return CartState(cartItems ?? this.cartItems);
  }

  @override
  List<Object?> get props => [cartItems, cartCount];
}

// Bloc Implementation
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc(this._cartRepository) : super(CartState([])) {
    // ✅ Load all cart items initially
    on<LoadCart>((event, emit) async {
      final cartItems = await _cartRepository.getAllCartItems();
      emit(CartState(cartItems));
    });

    // ✅ Add item to cart and update the UI
    on<AddToCart>((event, emit) async {
      await _cartRepository.addCartItem(
        event.product,
        selectedSize: event.selectedSize,
      );
      final cartItems = await _cartRepository.getAllCartItems();
      emit(CartState(cartItems));
    });

    // ✅ Remove item from cart and update the UI
    on<RemoveFromCart>((event, emit) async {
      await _cartRepository.removeProductById(event.product.id);
      final cartItems = await _cartRepository.getAllCartItems();
      emit(CartState(cartItems));
    });

    on<UpdateQuantity>((event, emit) async {
      try {
        List<CartItem> cartItems = await _cartRepository.getAllCartItems();

        int index = cartItems.indexWhere(
          (item) => item.product.id == event.productId,
        );

        if (index != -1) {
          cartItems[index] = cartItems[index].copyWith(
            quantity: event.newQuantity,
          );

          await _cartRepository.saveAllCarts(cartItems);

          // 🔥 Emit a new state to reflect changes in the UI
          emit(CartState(cartItems));
        }
      } catch (e, stackTrace) {
        print("Error updating cart: $e");
        print("StackTrace: $stackTrace");
      }
    });

    // ✅ Clear all cart items
    on<ClearAllCart>((event, emit) async {
      await _cartRepository.clearAllCarts();
      emit(CartState([]));
    });
  }
}
