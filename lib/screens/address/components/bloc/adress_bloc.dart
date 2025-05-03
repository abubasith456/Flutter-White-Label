import 'package:demo_app/models/address_model.dart';
import 'package:demo_app/repository/address_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class AddressEvent {}

class LoadAddresses extends AddressEvent {}

class AddAddress extends AddressEvent {
  final AddressModel address;
  AddAddress(this.address);
}

class UpdateAddress extends AddressEvent {
  final AddressModel address;
  UpdateAddress(this.address);
}

class SetPrimaryAddress extends AddressEvent {
  final String id;
  SetPrimaryAddress(this.id);
}

class DeleteAddress extends AddressEvent {
  final String id;
  DeleteAddress(this.id);
}

class SelectAddress extends AddressEvent {
  final AddressModel address;
  SelectAddress(this.address);
}

// States
class AddressState extends Equatable {
  final List<AddressModel> addresses;
  final AddressModel? selectedAddress;
  final bool isLoading;
  final String? errorMessage;
  final bool isActionSuccess;

  const AddressState({
    this.addresses = const [],
    this.selectedAddress,
    this.isLoading = false,
    this.errorMessage,
    this.isActionSuccess = false,
  });

  AddressState copyWith({
    List<AddressModel>? addresses,
    AddressModel? selectedAddress,
    bool? isLoading,
    String? errorMessage,
    bool? isActionSuccess,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isActionSuccess: isActionSuccess ?? this.isActionSuccess,
    );
  }

  @override
  List<Object?> get props => [
    addresses,
    selectedAddress,
    isLoading,
    errorMessage,
    isActionSuccess,
  ];
}

// Bloc Implementation
class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository _repository;

  AddressBloc(this._repository) : super(const AddressState(isLoading: true)) {
    on<LoadAddresses>(_onLoadAddresses);
    on<AddAddress>(_onAddAddress);
    on<UpdateAddress>(_onUpdateAddress);
    on<SetPrimaryAddress>(_onSetPrimaryAddress);
    on<DeleteAddress>(_onDeleteAddress);
    on<SelectAddress>(_onSelectAddress);
  }

  Future<void> _onLoadAddresses(
    LoadAddresses event,
    Emitter<AddressState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isActionSuccess: false,
      ),
    );
    try {
      final addresses = await _repository.getAddresses();

      // Find primary address if any
      final primaryAddress =
          addresses.isNotEmpty
              ? addresses.firstWhere(
                (addr) => addr.isPrimary,
                orElse: () => addresses.first,
              )
              : null;

      emit(
        state.copyWith(
          addresses: addresses,
          selectedAddress: primaryAddress,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "Failed to load addresses: $e",
        ),
      );
    }
  }

  Future<void> _onAddAddress(
    AddAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isActionSuccess: false,
      ),
    );

    try {
      // If this is the first address, make it primary
      final address =
          state.addresses.isEmpty
              ? event.address.copyWith(isPrimary: true)
              : event.address;

      final updatedList = List<AddressModel>.from(state.addresses)
        ..add(address);

      await _repository.saveAddresses(updatedList);

      emit(
        state.copyWith(
          addresses: updatedList,
          isLoading: false,
          isActionSuccess: true,
          // If this is the first address or it's primary, select it
          selectedAddress: address.isPrimary ? address : state.selectedAddress,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "Failed to add address: $e",
        ),
      );
    }
  }

  Future<void> _onUpdateAddress(
    UpdateAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isActionSuccess: false,
      ),
    );

    try {
      final updatedList =
          state.addresses.map((addr) {
            return addr.id == event.address.id ? event.address : addr;
          }).toList();

      await _repository.saveAddresses(updatedList);

      emit(
        state.copyWith(
          addresses: updatedList,
          isLoading: false,
          isActionSuccess: true,
          // Update selected address if it was the one modified
          selectedAddress:
              state.selectedAddress?.id == event.address.id
                  ? event.address
                  : state.selectedAddress,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "Failed to update address: $e",
        ),
      );
    }
  }

  Future<void> _onSetPrimaryAddress(
    SetPrimaryAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isActionSuccess: false,
      ),
    );

    try {
      final updatedList =
          state.addresses.map((addr) {
            return addr.id == event.id
                ? addr.copyWith(isPrimary: true)
                : addr.copyWith(isPrimary: false);
          }).toList();

      await _repository.saveAddresses(updatedList);

      // Find the new primary address
      final newPrimaryAddress = updatedList.firstWhere(
        (addr) => addr.id == event.id,
        orElse: () => updatedList.first,
      );

      emit(
        state.copyWith(
          addresses: updatedList,
          selectedAddress: newPrimaryAddress,
          isLoading: false,
          isActionSuccess: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "Failed to set primary address: $e",
        ),
      );
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        isActionSuccess: false,
      ),
    );

    try {
      // Check if we're deleting the primary address
      final isRemovingPrimary =
          state.addresses
              .firstWhere(
                (addr) => addr.id == event.id,
                orElse: () => state.addresses.first,
              )
              .isPrimary;

      final updatedList =
          state.addresses.where((addr) => addr.id != event.id).toList();

      // If we removed the primary address and there are other addresses,
      // make the first one primary
      if (isRemovingPrimary && updatedList.isNotEmpty) {
        updatedList[0] = updatedList[0].copyWith(isPrimary: true);
      }

      await _repository.saveAddresses(updatedList);

      // Update selected address if needed
      AddressModel? newSelectedAddress = state.selectedAddress;
      if (state.selectedAddress?.id == event.id) {
        newSelectedAddress =
            updatedList.isNotEmpty
                ? updatedList.firstWhere(
                  (addr) => addr.isPrimary,
                  orElse: () => updatedList.first,
                )
                : null;
      }

      emit(
        state.copyWith(
          addresses: updatedList,
          selectedAddress: newSelectedAddress,
          isLoading: false,
          isActionSuccess: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "Failed to delete address: $e",
        ),
      );
    }
  }

  void _onSelectAddress(SelectAddress event, Emitter<AddressState> emit) {
    emit(state.copyWith(selectedAddress: event.address, isActionSuccess: true));
  }
}
