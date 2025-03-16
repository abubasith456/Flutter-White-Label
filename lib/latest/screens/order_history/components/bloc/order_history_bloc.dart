// Bloc Events
import 'package:demo_app/latest/constants.dart';
import 'package:demo_app/latest/models/order_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OrderEvent {}

class LoadOrders extends OrderEvent {}

// Bloc States
abstract class OrderState {}

class OrderLoading extends OrderState {}

class OrderLoaded extends OrderState {
  final List<OrderModel> orders;
  OrderLoaded(this.orders);
}

class OrderError extends OrderState {}

// Bloc Implementation
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderLoading()) {
    on<LoadOrders>((event, emit) async {
      await Future.delayed(Duration(seconds: 1)); // Simulate loading
      emit(OrderLoaded(mockOrders));
    });
  }
}
