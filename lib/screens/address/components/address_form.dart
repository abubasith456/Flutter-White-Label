import 'package:demo_app/app_config.dart';
import 'package:demo_app/models/address_model.dart';
import 'package:flutter/material.dart';

class AddressForm extends StatefulWidget {
  final AddressModel? address;
  final Function(AddressModel) onSave;
  final VoidCallback onCancel;

  const AddressForm({
    Key? key,
    this.address,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _zipCodeController;
  late final TextEditingController _phoneController;

  bool _isPrimary = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.address != null;

    // Initialize controllers with existing values if editing
    _nameController = TextEditingController(text: widget.address?.name ?? '');
    _addressController = TextEditingController(
      text: widget.address?.address ?? '',
    );
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _stateController = TextEditingController(text: widget.address?.state ?? '');
    _zipCodeController = TextEditingController(
      text: widget.address?.zipCode ?? '',
    );
    _phoneController = TextEditingController(text: widget.address?.phone ?? '');

    _isPrimary = widget.address?.isPrimary ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _addressController,
            label: 'Street Address',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTextField(
                  controller: _cityController,
                  label: 'City',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _stateController,
                  label: 'State',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _zipCodeController,
                  label: 'ZIP Code',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Set as default address'),
            value: _isPrimary,
            activeColor: AppConfig.primaryColor,
            contentPadding: EdgeInsets.zero,
            onChanged: (value) {
              setState(() {
                _isPrimary = value;
              });
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onCancel,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: _saveAddress,
                child: Text(_isEditing ? 'Update' : 'Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final address = AddressModel(
        id:
            widget.address?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
        phone: _phoneController.text.trim(),
        isPrimary: _isPrimary,
      );

      widget.onSave(address);
    }
  }
}
