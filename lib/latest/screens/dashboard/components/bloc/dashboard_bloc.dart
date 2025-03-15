import 'package:flutter_bloc/flutter_bloc.dart';

// Bloc Events
abstract class DashboardEvent {}

class UpdateTab extends DashboardEvent {
  final int index;
  UpdateTab(this.index);
}

// Bloc State
class DashboardState {
  final int currentIndex;
  DashboardState(this.currentIndex);
}

// Bloc Implementation
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardState(0)) {
    on<UpdateTab>((event, emit) {
      emit(DashboardState(event.index));
    });
  }
}
