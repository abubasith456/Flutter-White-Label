import 'package:demo_app/app_config.dart';
import 'package:demo_app/components/base/custom_appbar.dart';
import 'package:demo_app/models/address_model.dart';
import 'package:demo_app/screens/address/components/address_card.dart';
import 'package:demo_app/screens/address/components/address_form.dart';
import 'package:demo_app/screens/address/components/bloc/adress_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressScreen extends StatefulWidget {
  final bool isSelectionMode;

  const AddressScreen({super.key, this.isSelectionMode = false});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger address load event when screen opens
    context.read<AddressBloc>().add(LoadAddresses());
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar color to match the app's theme
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppConfig.primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.isSelectionMode ? "Select Address" : "My Addresses",
        showActionButton: widget.isSelectionMode && _hasSelectedAddress(),
        actionIcon: Icons.confirmation_num,
        onAction: () {
          if (_hasSelectedAddress()) {
            _confirmSelection();
          }
        },
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          // Show error message if there's an error
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }

          // Show success message after successful actions
          if (state.isActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Address updated successfully"),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    "No addresses found",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Tap the + button to add a new address",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.addresses.length,
            itemBuilder: (context, index) {
              final address = state.addresses[index];
              final isSelected =
                  widget.isSelectionMode &&
                  state.selectedAddress?.id == address.id;

              return AddressCard(
                address: address,
                isSelected: isSelected,
                onTap: () => _handleAddressTap(address),
                onEdit: () => _showAddressForm(address),
                onDelete: () => _confirmDelete(address.id),
                onSetDefault: () => _setAsDefault(address.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddressForm(),
        backgroundColor: AppConfig.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  bool _hasSelectedAddress() {
    final state = context.read<AddressBloc>().state;
    return state.selectedAddress != null;
  }

  void _confirmSelection() {
    final state = context.read<AddressBloc>().state;
    if (state.selectedAddress != null) {
      Navigator.pop(context, state.selectedAddress);
    }
  }

  void _handleAddressTap(AddressModel address) {
    if (widget.isSelectionMode) {
      // In selection mode, just select the address
      context.read<AddressBloc>().add(SelectAddress(address));
    } else {
      // In normal mode, set as default
      _setAsDefault(address.id);
    }
  }

  void _setAsDefault(String id) {
    context.read<AddressBloc>().add(SetPrimaryAddress(id));
  }

  void _showAddressForm([AddressModel? address]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          address == null ? 'Add New Address' : 'Edit Address',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 16),
                    AddressForm(
                      address: address,
                      onSave: (newAddress) {
                        if (address == null) {
                          // Add new address
                          context.read<AddressBloc>().add(
                            AddAddress(newAddress),
                          );
                        } else {
                          // Update existing address
                          context.read<AddressBloc>().add(
                            UpdateAddress(newAddress),
                          );
                        }
                        Navigator.pop(context);
                      },
                      onCancel: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Address"),
            content: const Text(
              "Are you sure you want to delete this address?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  context.read<AddressBloc>().add(DeleteAddress(id));
                  Navigator.pop(context);
                },
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
