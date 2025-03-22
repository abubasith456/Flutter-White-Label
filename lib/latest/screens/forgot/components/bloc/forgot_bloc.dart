import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_app/latest/repository/auth_repo/auth_repository.dart';

// Event Definitions
abstract class ForgotPasswordEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  final String email;
  ForgotPasswordSubmitted(this.email);

  @override
  List<Object> get props => [email];
}

// State Definitions
abstract class ForgotPasswordState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String errorMessage;
  ForgotPasswordFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

// BLoC
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository authRepository;

  ForgotPasswordBloc({required this.authRepository})
    : super(ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>((event, emit) async {
      if (event.email.isEmpty || !event.email.contains('@')) {
        emit(ForgotPasswordFailure('Please enter a valid email address.'));
        return;
      }

      emit(ForgotPasswordLoading());

      try {
        // final apiResponse = await authRepository.forgotPassword(event.email);

        // if (apiResponse.success) {
        //   emit(ForgotPasswordSuccess());
        // } else {
        //   emit(ForgotPasswordFailure(apiResponse.message));
        // }
      } catch (error) {
        emit(ForgotPasswordFailure('An error occurred. Please try again.'));
      }
    });
  }
}
