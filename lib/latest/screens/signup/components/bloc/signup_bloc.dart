import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class SignupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignupNameChanged extends SignupEvent {
  final String name;
  SignupNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class SignupEmailChanged extends SignupEvent {
  final String email;
  SignupEmailChanged(this.email);

  @override
  List<Object> get props => [email];
}

class SignupPasswordChanged extends SignupEvent {
  final String password;
  SignupPasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class SignupDobChanged extends SignupEvent {
  final String dob;
  SignupDobChanged(this.dob);

  @override
  List<Object> get props => [dob];
}

class SignupSubmitted extends SignupEvent {
  SignupSubmitted(String text, String text2, String text3, String text4);
}

// State
class SignupState extends Equatable {
  final String name;
  final String email;
  final String password;
  final String dob;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  const SignupState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.dob = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.isFailure = false,
  });

  SignupState copyWith({
    String? name,
    String? email,
    String? password,
    String? dob,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
  }) {
    return SignupState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      dob: dob ?? this.dob,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  @override
  List<Object> get props => [
    name,
    email,
    password,
    dob,
    isSubmitting,
    isSuccess,
    isFailure,
  ];
}

// Bloc
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(const SignupState()) {
    on<SignupNameChanged>((event, emit) {
      emit(state.copyWith(name: event.name));
    });

    on<SignupEmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<SignupPasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<SignupDobChanged>((event, emit) {
      emit(state.copyWith(dob: event.dob));
    });

    on<SignupSubmitted>((event, emit) async {
      emit(state.copyWith(isSubmitting: true));

      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    });
  }
}
