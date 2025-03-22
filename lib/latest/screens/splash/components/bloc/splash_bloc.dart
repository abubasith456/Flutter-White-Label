import 'package:demo_app/latest/components/base_bloc/profile_bloc.dart';
import 'package:demo_app/latest/models/api_model/user_model.dart';
import 'package:demo_app/latest/services/service_locator.dart';
import 'package:demo_app/latest/services/shared_pref_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SplashEvent {}

class SplashStarted extends SplashEvent {}

abstract class SplashState {}

class SplashInitial extends SplashState {}

class NavigateToOnBoard extends SplashState {}

class NavigateToLogin extends SplashState {}

class NavigateToDashBoard extends SplashState {
  final User activatedUser;

  NavigateToDashBoard({required this.activatedUser});
}

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final SharedPrefService sharedPrefService; // Inject ProfileBloc

  SplashBloc({required this.sharedPrefService}) : super(SplashInitial()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(
    SplashStarted event,
    Emitter<SplashState> emit,
  ) async {
    await Future.delayed(Duration(seconds: 5));

    final onBoardDone = sharedPrefService.getOnboardPassed();
    final isUserActive = sharedPrefService.getUser();

    if (!onBoardDone) {
      emit(NavigateToOnBoard());
    } else if (isUserActive != null) {
      emit(NavigateToDashBoard(activatedUser: isUserActive));
    } else {
      emit(NavigateToLogin());
    }
  }
}
