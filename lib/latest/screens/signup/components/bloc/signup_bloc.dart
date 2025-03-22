import 'package:demo_app/latest/models/api_model/user_model.dart';
import 'package:demo_app/latest/repository/auth_repo/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

// Event Definitions
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
  final String name;
  final String email;
  final String password;
  final String dob;

  SignupSubmitted(this.name, this.email, this.password, this.dob);

  @override
  List<Object> get props => [name, email, password, dob];
}

// State Definitions
abstract class SignupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final User user;
  SignupSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class SignupFailure extends SignupState {
  final String errorMessage;
  SignupFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class SignupFieldError extends SignupState {
  final String errorMessage;
  SignupFieldError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

// BLoC
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepository authRepository;

  SignupBloc({required this.authRepository}) : super(SignupInitial()) {
    on<SignupNameChanged>((event, emit) {
      emit(
        SignupFieldError(
          _validateName(event.name)
              ? ''
              : 'Name must be at least 3 characters long',
        ),
      );
    });

    on<SignupEmailChanged>((event, emit) {
      emit(
        SignupFieldError(
          _validateEmail(event.email) ? '' : 'Invalid email format',
        ),
      );
    });

    on<SignupPasswordChanged>((event, emit) {
      emit(
        SignupFieldError(
          _validatePassword(event.password)
              ? ''
              : 'Password must be at least 6 characters long',
        ),
      );
    });

    on<SignupDobChanged>((event, emit) {
      emit(
        SignupFieldError(
          _validateDob(event.dob) ? '' : 'Date of birth is required',
        ),
      );
    });

    on<SignupSubmitted>((event, emit) async {
      // Validate fields before proceeding with signup
      if (!_validateName(event.name) ||
          !_validateEmail(event.email) ||
          !_validatePassword(event.password) ||
          !_validateDob(event.dob)) {
        emit(
          SignupFieldError(
            'Please provide valid name, email, password, and date of birth.',
          ),
        );
        return;
      }

      // Proceed with signup if fields are valid
      emit(SignupLoading());

      try {
        final apiResponse = await authRepository.register(
          event.name,
          event.email,
          "",
          event.dob,
          event.password,
        );

        print(" Response from Bloc $apiResponse");

        if (apiResponse.success) {
          print("SignupSuccess emited");
          emit(SignupSuccess(apiResponse.data!));
        } else {
          emit(SignupFailure(apiResponse.message));
        }
      } catch (error) {
        emit(SignupFailure('An error occurred. Please try again.'));
      }
    });
  }

  bool _validateName(String name) {
    // Validate name: Should be at least 3 characters
    return name.length >= 3;
  }

  bool _validateEmail(String email) {
    // Simple email validation
    return email.contains('@');
  }

  bool _validatePassword(String password) {
    // Password should be at least 6 characters
    return password.length >= 6;
  }

  bool _validateDob(String dob) {
    // Validate date of birth (just check if it's not empty for now)
    return dob.isNotEmpty;
  }
}
