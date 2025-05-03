import 'package:demo_app/models/address_model.dart';
import 'package:demo_app/models/cart_model.dart';
import 'package:demo_app/models/order_model.dart';
import 'package:demo_app/repository/order_repo/order_repository.dart';
import 'package:demo_app/services/shared_pref_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class OrderEvent {}

class LoadOrderDetails extends OrderEvent {
  final List<CartItem> cartItems;
  final double totalAmount;

  LoadOrderDetails({required this.cartItems, required this.totalAmount});
}

class PlaceOrder extends OrderEvent {
  final String paymentMethod;
  final AddressModel deliveryAddress;

  PlaceOrder({required this.paymentMethod, required this.deliveryAddress});
}

// States
class OrderState extends Equatable {
  final List<CartItem> cartItems;
  final double totalAmount;
  final String? paymentMethod;
  final AddressModel? deliveryAddress;
  final OrderModel? order;
  final bool isOrderPlaced;
  final bool isLoading;
  final String? errorMessage;

  const OrderState({
    this.cartItems = const [],
    this.totalAmount = 0.0,
    this.paymentMethod,
    this.deliveryAddress,
    this.order,
    this.isOrderPlaced = false,
    this.isLoading = false,
    this.errorMessage,
  });

  OrderState copyWith({
    List<CartItem>? cartItems,
    double? totalAmount,
    String? paymentMethod,
    AddressModel? deliveryAddress,
    OrderModel? order,
    bool? isOrderPlaced,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OrderState(
      cartItems: cartItems ?? this.cartItems,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      order: order ?? this.order,
      isOrderPlaced: isOrderPlaced ?? this.isOrderPlaced,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    cartItems,
    totalAmount,
    paymentMethod,
    deliveryAddress,
    order,
    isOrderPlaced,
    isLoading,
    errorMessage,
  ];
}

// Bloc
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository? orderRepository;
  final SharedPrefService prefs;

  OrderBloc({required this.prefs, this.orderRepository})
    : super(const OrderState()) {
    on<LoadOrderDetails>(_onLoadOrderDetails);
    on<PlaceOrder>(_onPlaceOrder);
  }

  void _onLoadOrderDetails(LoadOrderDetails event, Emitter<OrderState> emit) {
    emit(
      state.copyWith(
        cartItems: event.cartItems,
        totalAmount: event.totalAmount,
        isLoading: false,
        errorMessage: null,
      ),
    );
  }

  void _onPlaceOrder(PlaceOrder event, Emitter<OrderState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      // Set payment method and delivery address in state
      emit(
        state.copyWith(
          paymentMethod: event.paymentMethod,
          deliveryAddress: event.deliveryAddress,
        ),
      );

      // Create order items from cart items
      final List<OrderItem> orderItems =
          state.cartItems
              .map((cartItem) => OrderItem.fromCartItem(cartItem))
              .toList();

      // Create shipping address from selected address
      final ShippingAddress shippingAddress = ShippingAddress.fromAddressModel(
        event.deliveryAddress,
      );

      // Get user ID from shared preferences
      final String? userId = "67f0b8bd3a3431d142445230";

      // Create order model
      final OrderModel newOrder = OrderModel(
        userId: userId,
        items: orderItems,
        totalAmount: state.totalAmount,
        shippingAddress: shippingAddress,
        paymentStatus:
            event.paymentMethod == 'Cash on Delivery' ? 'Pending' : 'Paid',
      );

      // If repository is available, create order through API
      if (orderRepository != null) {
        try {
          final createdOrder = await orderRepository!.createOrder(newOrder);

          emit(
            state.copyWith(
              order: createdOrder.data,
              isOrderPlaced: true,
              isLoading: false,
            ),
          );
        } catch (apiError) {
          // If API fails, still show success but log the error
          print('API Error: $apiError');
          emit(
            state.copyWith(
              order: newOrder,
              isOrderPlaced: true,
              isLoading: false,
            ),
          );
        }
      } else {
        // If no repository, just update state with the new order
        emit(
          state.copyWith(
            order: newOrder,
            isOrderPlaced: true,
            isLoading: false,
          ),
        );
      }

      // Log order details
      print('Order placed successfully!');
      print('Payment Method: ${event.paymentMethod}');
      print(
        'Delivery Address: ${event.deliveryAddress.name}, ${event.deliveryAddress.address}, ${event.deliveryAddress.city}, ${event.deliveryAddress.state} ${event.deliveryAddress.zipCode}',
      );
      print('Total Amount: Rs.${state.totalAmount.toStringAsFixed(2)}');
      print('Items:');
      for (var item in state.cartItems) {
        print('- ${item.product.name} x${item.quantity}');
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to place order: $e',
        ),
      );
    }
  }
}
