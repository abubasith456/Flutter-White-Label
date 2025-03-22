import 'package:demo_app/latest/models/api_model/user_model.dart';
import 'package:demo_app/latest/repository/auth_repo/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:demo_app/latest/models/api_model/user_model.dart';

// Event Definitions
abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EmailChanged extends LoginEvent {
  final String email;
  EmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends LoginEvent {
  final String password;
  PasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  LoginSubmitted(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

// State Definitions
abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;
  LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginFailure extends LoginState {
  final String errorMessage;
  LoginFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class LoginFieldError extends LoginState {
  final String errorMessage;
  LoginFieldError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

// BLoC
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<EmailChanged>((event, emit) {
      emit(
        LoginFieldError(
          _validateEmail(event.email) ? '' : 'Invalid email format',
        ),
      );
    });

    on<PasswordChanged>((event, emit) {
      emit(
        LoginFieldError(
          _validatePassword(event.password)
              ? ''
              : 'Password must be at least 6 characters',
        ),
      );
    });

    on<LoginSubmitted>((event, emit) async {
      // Validate input fields before proceeding with login
      if (!_validateEmail(event.email) || !_validatePassword(event.password)) {
        emit(LoginFieldError('Please provide valid email and password.'));
        return;
      }

      // Proceed with login if fields are valid
      emit(LoginLoading());

      try {
        final apiResponse = await authRepository.login(
          event.email,
          event.password,
        );

        print(" Response from Bloc $apiResponse");

        if (apiResponse.success) {
          emit(
            LoginSuccess(apiResponse.data!),
          ); // Assuming response contains user info
        } else {
          emit(
            LoginFailure(apiResponse.message),
          ); // Assuming response has message for failure
        }
      } catch (error) {
        emit(LoginFailure('An error occurred. Please try again.'));
      }
    });
  }

  bool _validateEmail(String email) {
    // Simple email validation logic
    return email.contains('@');
  }

  bool _validatePassword(String password) {
    // Password should be at least 6 characters long
    return password.length >= 6;
  }
}
