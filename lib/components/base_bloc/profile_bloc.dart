import 'package:demo_app/models/api_model/user_model.dart';
import 'package:demo_app/repository/api_model/api_response.dart';
import 'package:demo_app/repository/auth_repo/auth_repository.dart';
import 'package:demo_app/services/service_locator.dart';
import 'package:demo_app/services/shared_pref_service.dart';
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
  final String userId;
  final String username;
  final String email;
  final String dob;
  final String mobile;
  final String profilePicUrl;

  UpdateProfile({
    required this.userId,
    required this.username,
    required this.email,
    required this.dob,
    required this.mobile,
    required this.profilePicUrl,
  });

  @override
  List<Object> get props => [
    userId,
    username,
    email,
    dob,
    mobile,
    profilePicUrl,
  ];
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
    print("LoadProfile called with userId: ${event.userId}");
    try {
      // Fetch profile data using the userId from the event
      ApiResponse<User> response = await _authRepository.getProfile(
        event.userId, // Use the userId passed in the event
      );
      print(response.data);
      if (response.success) {
        if (response.data != null) {
          sl<SharedPrefService>().setUser(response.data!);
          emit(ProfileLoaded(user: response.data!));
        } else {
          emit(ProfileError('Failed to load profile'));
        }
      } else {
        // If response is not successful, emit error state
        emit(ProfileError('Failed to load profile'));
      }
    } catch (e) {
      print("CATCH called");
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

      print(
        "ProfileBloc: UpdateProfile called with userId: ${event.profilePicUrl}",
      );

      final response = await _authRepository.updateProfile(
        event.userId,
        event.username,
        event.dob,
        event.mobile,
        event.profilePicUrl,
      );

      if (response.success && response.data != null) {
        print("Profile updated successfully");
        print("Profile data: ${response.data?.profilePic}");
        // Update local storage
        sl<SharedPrefService>().setUser(response.data!);
        emit(ProfileLoaded(user: response.data!));
      } else {
        emit(ProfileError("Failed to update profile"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    sl<SharedPrefService>().clearUser();
    await Future.delayed(Duration(seconds: 2)); // Simulating logout process
    emit(LogoutSuccess());
  }
}
