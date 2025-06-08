import 'package:flutter/material.dart';
import 'package:demo_app/app_config.dart';
import 'package:demo_app/models/address_model.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSetDefault;

  const AddressCard({
    super.key,
    required this.address,
    this.isSelected = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? AppConfig.primaryColor.withOpacity(0.1)
                      : AppConfig.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isSelected
                        ? AppConfig.primaryColor
                        : AppConfig.greyColor.withOpacity(0.2),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConfig.shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildAddressText(),
                const SizedBox(height: 8),
                _buildContactInfo(),
                const SizedBox(height: 16),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConfig.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getAddressIcon(),
            color: AppConfig.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppConfig.primaryTextColor,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        if (isSelected)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppConfig.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: AppConfig.primaryButtonTextColor,
              size: 16,
            ),
          ),
      ],
    );
  }

  Widget _buildAddressText() {
    return Text(
      address.fullAddress,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppConfig.primaryTextColor.withOpacity(0.8),
        height: 1.4,
        letterSpacing: 0.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildContactInfo() {
    return Row(
      children: [
        Icon(Icons.phone_rounded, size: 16, color: AppConfig.greyColor),
        const SizedBox(width: 6),
        Text(
          address.phone.isNotEmpty ? address.phone : 'No phone',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppConfig.primaryTextColor.withOpacity(0.7),
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        if (address.isPrimary)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppConfig.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppConfig.successColor, width: 1),
            ),
            child: Text(
              'Default',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConfig.successColor,
                letterSpacing: 0.2,
              ),
            ),
          ),
        const Spacer(),
        _buildActionButton(
          icon: Icons.edit_outlined,
          onPressed: onEdit,
          color: AppConfig.primaryColor,
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.more_vert,
          onPressed: () => _showOptionsMenu(),
          color: AppConfig.greyColor,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color color,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: color),
        padding: EdgeInsets.zero,
        splashRadius: 18,
      ),
    );
  }

  IconData _getAddressIcon() {
    return Icons.location_on_outlined;
  }

  void _showOptionsMenu() {
    // Implementation for showing options menu (set as default, delete, etc.)
    // This would typically show a popup menu or bottom sheet
  }
}
