import 'package:demo_app/app_config.dart';
import 'package:demo_app/models/address_model.dart';
import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const AddressCard({
    Key? key,
    required this.address,
    this.isSelected = false,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppConfig.primaryColor : Colors.transparent,
          width: isSelected ? 2 : 0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and default badge
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          address.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (address.isPrimary)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppConfig.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppConfig.primaryColor,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Default',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppConfig.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Action buttons
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: onEdit,
                        tooltip: 'Edit',
                        color: Colors.blue,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        onPressed: onDelete,
                        tooltip: 'Delete',
                        color: Colors.red,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Address details
              Text(
                address.fullAddress,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                address.phone,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),

              // Set as default button (only show if not already default)
              if (!address.isPrimary) ...[
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: onSetDefault,
                  icon: const Icon(Icons.check_circle_outline, size: 16),
                  label: const Text('Set as default'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppConfig.primaryColor,
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    textStyle: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
