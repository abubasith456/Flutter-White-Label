import 'package:demo_app/latest/models/api_model/user_model.dart';
import 'package:demo_app/latest/repository/api_model/api_response.dart';
import 'package:demo_app/latest/repository/auth_repo/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Event
abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

abstract class EditProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String userId;

  LoadProfile({required this.userId});
}

class EditProfile extends EditProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String username;
  final String email;
  final String dob;
  final String profilePicUrl;

  UpdateProfile({
    required this.username,
    required this.email,
    required this.dob,
    required this.profilePicUrl,
  });

  @override
  List<Object> get props => [username, email, dob, profilePicUrl];
}

class ViewAddress extends ProfileEvent {}

class ViewOrderHistory extends ProfileEvent {}

class ViewNotifications extends ProfileEvent {}

class Logout extends ProfileEvent {}

// State

abstract class ProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

abstract class EditProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  ProfileLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class LogoutSuccess extends ProfileState {}

// Block
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;

  ProfileBloc(this._authRepository) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<Logout>(_onLogout);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      // Fetch profile data using the userId from the event
      ApiResponse<User> response = await _authRepository.getProfile(
        event.userId, // Use the userId passed in the event
      );

      if (response.success) {
        // Emit ProfileLoaded state with the User data
        emit(ProfileLoaded(user: response.data!));
      } else {
        // If response is not successful, emit error state
        emit(ProfileError('Failed to load profile'));
      }
    } catch (e) {
      // Handle any errors that occur during fetching
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());

      // Need to work
      // await _authRepository.updateProfile(
      //   event.username,
      //   event.email,
      //   event.dob,
      //   event.profilePicUrl,
      // );

      emit(
        ProfileLoaded(
          user: User(
            id: "0",
            name: event.username,
            email: event.email,
            mobile: "",
            images: [],
            dob: event.dob,
            addresses: [],
          ),
        ),
      );
    } catch (e) {
      emit(ProfileError("Failed to update profile"));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    await Future.delayed(Duration(seconds: 5)); // Simulating logout process
    emit(LogoutSuccess());
  }
}
