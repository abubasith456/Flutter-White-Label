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

class LoadProfile extends ProfileEvent {}

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
  final String username;
  final String email;
  final String dob;
  final String profilePicUrl;

  ProfileLoaded({
    required this.username,
    required this.email,
    required this.dob,
    required this.profilePicUrl,
  });

  @override
  List<Object> get props => [username, profilePicUrl, email, dob];
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
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<Logout>(_onLogout);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    await Future.delayed(Duration(seconds: 2)); // Simulating API call

    emit(
      ProfileLoaded(
        username: "Mohamed Abu Basith S",
        email: "Test123@gmail.com",
        dob: "13-04-2000",
        profilePicUrl:
            "https://i.pinimg.com/474x/fa/d5/e7/fad5e79954583ad50ccb3f16ee64f66d.jpg",
      ),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoading());
      emit(
        ProfileLoaded(
          username: event.username,
          email: event.email,
          dob: event.dob,
          profilePicUrl: event.profilePicUrl,
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
