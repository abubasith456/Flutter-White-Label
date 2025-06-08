import 'package:demo_app/app_config.dart';
import 'package:demo_app/screens/address/components/bloc/adress_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressSelector extends StatelessWidget {
  final VoidCallback onAddressChange;

  const AddressSelector({Key? key, required this.onAddressChange})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, addressState) {
        if (addressState.isLoading) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 3));
        }

        if (addressState.addresses.isEmpty) {
          return _buildNoAddressCard();
        }

        final selectedAddress =
            addressState.selectedAddress ?? addressState.addresses.first;

        return _buildSelectedAddressCard(selectedAddress);
      },
    );
  }

  Widget _buildNoAddressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.location_off, size: 48, color: Colors.orange[600]),
          const SizedBox(height: 12),
          Text(
            'No addresses found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.orange[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please add a delivery address to continue',
            style: TextStyle(fontSize: 14, color: Colors.orange[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onAddressChange,
            icon: const Icon(Icons.add),
            label: const Text('Add New Address'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConfig.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAddressCard(selectedAddress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        selectedAddress.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedAddress.isPrimary)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppConfig.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppConfig.primaryColor, width: 1),
                  ),
                  child: Text(
                    'Default',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppConfig.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            selectedAddress.fullAddress,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            selectedAddress.phone,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onAddressChange,
            icon: const Icon(Icons.edit_location_alt, size: 18),
            label: const Text('Change Address'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppConfig.primaryColor,
              side: BorderSide(color: AppConfig.primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}
