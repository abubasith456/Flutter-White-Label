import 'package:demo_app/latest/models/address_model.dart';
import 'package:demo_app/latest/repository/address_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class AddressEvent {}

class LoadAddresses extends AddressEvent {}

class AddAddress extends AddressEvent {
  final AddressModel address;
  AddAddress(this.address);
}

class SetPrimaryAddress extends AddressEvent {
  final String id;
  SetPrimaryAddress(this.id);
}

class DeleteAddress extends AddressEvent {
  final String id;
  DeleteAddress(this.id);
}

// States
abstract class AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<AddressModel> addresses;
  final bool isAddingAction;
  AddressLoaded(this.addresses, {this.isAddingAction = false});
}

class AddressEmpty extends AddressState {}

class AddressError extends AddressState {
  final String message;
  AddressError(this.message);
}

// Bloc Implementation
class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository _repository;

  AddressBloc(this._repository) : super(AddressLoading()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<AddAddress>(_onAddAddress);
    on<SetPrimaryAddress>(_onSetPrimaryAddress);
    on<DeleteAddress>(_onDeleteAddress);
  }

  Future<void> _onLoadAddresses(
    LoadAddresses event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final addresses = await _repository.getAddresses();
      if (addresses.isEmpty) {
        emit(AddressEmpty());
      } else {
        emit(AddressLoaded(addresses));
      }
    } catch (e) {
      emit(AddressError("Failed to load addresses."));
    }
  }

  Future<void> _onAddAddress(
    AddAddress event,
    Emitter<AddressState> emit,
  ) async {
    final state = this.state;
    print("_onAddAddress BLOCK CALLED $state");

    List<AddressModel> updatedList = [];

    if (state is AddressLoaded) {
      updatedList = List<AddressModel>.from(state.addresses)
        ..add(event.address);
    } else if (state is AddressEmpty) {
      // Handle the case where no addresses exist yet
      updatedList = [event.address];
    } else {
      emit(AddressError("Cannot add address in the current state."));
      return;
    }

    print("On add: $updatedList");

    try {
      print("TRY BLOCK CALLED");
      await _repository.saveAddresses(updatedList); // Persist data
      emit(AddressLoaded(updatedList)); // Emit updated state
    } catch (e) {
      print("Error saving address: $e");
      emit(state); // Restore previous state on failure
    }
  }

  Future<void> _onSetPrimaryAddress(
    SetPrimaryAddress event,
    Emitter<AddressState> emit,
  ) async {
    final state = this.state;
    if (state is AddressLoaded) {
      final updatedList =
          state.addresses.map((addr) {
            return addr.id == event.id
                ? addr.copyWith(isPrimary: true)
                : addr.copyWith(isPrimary: false);
          }).toList();

      await _repository.saveAddresses(updatedList);
      emit(AddressLoaded(updatedList, isAddingAction: true));
    } else {
      emit(AddressError("Cannot set primary address in the current state."));
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddress event,
    Emitter<AddressState> emit,
  ) async {
    final state = this.state;
    if (state is AddressLoaded) {
      final updatedList =
          state.addresses.where((addr) => addr.id != event.id).toList();

      await _repository.saveAddresses(updatedList);
      emit(updatedList.isEmpty ? AddressEmpty() : AddressLoaded(updatedList));
    } else {
      emit(AddressError("Cannot delete address in the current state."));
    }
  }
}
