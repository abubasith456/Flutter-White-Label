import 'package:demo_app/models/order_model.dart';
import 'package:demo_app/repository/order_repo/order_repository.dart';
import 'package:demo_app/services/shared_pref_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Bloc Events
abstract class OrderHistoryEvent {}

class LoadOrderHistory extends OrderHistoryEvent {}

class CancelOrderHistory extends OrderHistoryEvent {
  final String orderId;
  CancelOrderHistory(this.orderId);
}

// Bloc States
abstract class OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  final List<OrderModel> orders;
  OrderHistoryLoaded(this.orders);
}

class OrderHistoryError extends OrderHistoryState {
  final String message;
  OrderHistoryError(this.message);
}

// Bloc Implementation
class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  final OrderRepository orderRepository;
  final SharedPrefService pref;

  OrderHistoryBloc({required this.pref, required this.orderRepository})
    : super(OrderHistoryLoading()) {
    on<LoadOrderHistory>(_onLoadOrders);
    on<CancelOrderHistory>(_onCancelOrder);
  }

  Future<void> _onLoadOrders(
    LoadOrderHistory event,
    Emitter<OrderHistoryState> emit,
  ) async {
    emit(OrderHistoryLoading());
    final activeUser = pref.getUser();
    try {
      final orders = await orderRepository.getUserOrders(activeUser?.id ?? '1');
      emit(OrderHistoryLoaded(orders.data ?? []));
    } catch (e) {
      emit(OrderHistoryError('Failed to load orders: $e'));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrderHistory event,
    Emitter<OrderHistoryState> emit,
  ) async {
    try {
      // Keep the current state while processing
      final activeUser = pref.getUser();

      // Cancel the order
      await orderRepository.cancelOrder(event.orderId);

      // Reload orders to get the updated list
      final orders = await orderRepository.getUserOrders(activeUser?.id ?? '1');
      emit(OrderHistoryLoaded(orders.data ?? []));
    } catch (e) {
      emit(OrderHistoryError('Failed to cancel order: $e'));
    }
  }
}
