// Event

import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

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
  LoginSubmitted(String text, String text2);
}

// State
enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isValid;
  final LoginStatus status;
  final String? errorMessage;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isValid = false,
    this.status = LoginStatus.initial,
    this.errorMessage,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isValid,
    LoginStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, password, isValid, status, errorMessage];
}

//Blco

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<EmailChanged>((event, emit) {
      emit(
        state.copyWith(
          email: event.email,
          isValid: _validate(event.email, state.password),
        ),
      );
    });

    on<PasswordChanged>((event, emit) {
      emit(
        state.copyWith(
          password: event.password,
          isValid: _validate(state.email, event.password),
        ),
      );
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(status: LoginStatus.loading));
      await Future.delayed(Duration(seconds: 2));
      emit(state.copyWith(status: LoginStatus.success));
    });
  }

  bool _validate(String email, String password) {
    return email.contains('@') && password.length >= 6;
  }
}
