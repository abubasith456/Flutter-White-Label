// order_details_event.dart
import 'package:bloc/bloc.dart';
import 'package:demo_app/models/order_model.dart';
import 'package:demo_app/repository/order_repo/order_repository.dart';

abstract class OrderDetailsEvent {}

class LoadOrderDetails extends OrderDetailsEvent {
  final String orderId;
  LoadOrderDetails({required this.orderId});
}

// order_details_state.dart
abstract class OrderDetailsState {}

class OrderDetailsInitial extends OrderDetailsState {}

class OrderDetailsLoading extends OrderDetailsState {}

class OrderDetailsLoaded extends OrderDetailsState {
  final OrderModel order;
  OrderDetailsLoaded(this.order);
}

class OrderDetailsError extends OrderDetailsState {
  final String message;
  OrderDetailsError(this.message);
}

// order_details_bloc.dart
class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final OrderRepository orderRepository;

  OrderDetailsBloc({required this.orderRepository})
    : super(OrderDetailsInitial()) {
    on<LoadOrderDetails>(_onLoadOrderDetails);
  }

  Future<void> _onLoadOrderDetails(
    LoadOrderDetails event,
    Emitter<OrderDetailsState> emit,
  ) async {
    emit(OrderDetailsLoading());
    try {
      final response = await orderRepository.getOrderById(event.orderId);
      if (response.success && response.data != null) {
        emit(OrderDetailsLoaded(response.data!));
      } else {
        emit(
          OrderDetailsError(response.message ?? 'Failed to load order details'),
        );
      }
    } catch (e) {
      emit(OrderDetailsError(e.toString()));
    }
  }
}
