import 'package:flutter_bloc/flutter_bloc.dart';

// Bloc Events
abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {}

// Bloc States
abstract class NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<String> notifications;
  NotificationLoaded(this.notifications);
}

class NotificationEmpty extends NotificationState {}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}

// Bloc Implementation
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationLoading()) {
    on<LoadNotifications>(_onLoadNotifications);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    await Future.delayed(Duration(seconds: 1)); // Simulating API delay
    List<String> mockNotifications = [
      "Your order #1234 has been shipped!",
      "Limited-time offer! Get 20% off on your next purchase.",
      "Your refund for order #5678 has been processed.",
    ];
    if (mockNotifications.isEmpty) {
      emit(NotificationEmpty());
    } else {
      emit(NotificationLoaded(mockNotifications));
    }
  }
}
