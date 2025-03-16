import 'package:demo_app/latest/models/address_model.dart';
import 'package:demo_app/latest/screens/address/components/bloc/adress_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

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
    return Scaffold(
      appBar: AppBar(title: const Text("Select Address")),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state is AddressLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AddressLoaded) {
            if (state.addresses.isEmpty) {
              return const Center(
                child: Text(
                  "No addresses found.\nTap '+' to add a new address.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return ListView.builder(
              itemCount: state.addresses.length,
              itemBuilder: (context, index) {
                final address = state.addresses[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: Icon(
                      address.isPrimary
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: address.isPrimary ? Colors.green : Colors.grey,
                    ),
                    title: Text(
                      address.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${address.address}\n${address.phone}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, address.id),
                    ),
                    onTap: () {
                      context.read<AddressBloc>().add(
                        SetPrimaryAddress(address.id),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Something went wrong"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAddressDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Show confirmation dialog before deleting an address
  void _confirmDelete(BuildContext context, String id) {
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
                onPressed: () {
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
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

  /// Show dialog for adding a new address
  void _showAddAddressDialog(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Add Address"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, "Name"),
                _buildTextField(addressController, "Address"),
                _buildTextField(phoneController, "Phone"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final newAddress = AddressModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text.trim(),
                    address: addressController.text.trim(),
                    phone: phoneController.text.trim(),
                    isPrimary: false,
                  );

                  if (newAddress.name.isNotEmpty &&
                      newAddress.address.isNotEmpty &&
                      newAddress.phone.isNotEmpty) {
                    context.read<AddressBloc>().add(AddAddress(newAddress));
                    // Navigator.pop(context);
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
    ).then((_) {
      // Dispose controllers to free memory
      nameController.dispose();
      addressController.dispose();
      phoneController.dispose();
    });
  }

  /// Custom text field widget
  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
