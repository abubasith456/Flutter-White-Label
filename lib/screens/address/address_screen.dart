import 'package:demo_app/app_config.dart';
import 'package:demo_app/components/base/custom_appbar.dart';
import 'package:demo_app/models/address_model.dart';
import 'package:demo_app/screens/address/components/address_card.dart';
import 'package:demo_app/screens/address/components/address_form.dart';
import 'package:demo_app/screens/address/components/bloc/adress_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressScreen extends StatefulWidget {
  final bool isSelectionMode;

  const AddressScreen({super.key, this.isSelectionMode = false});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  late AnimationController _listAnimationController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    );

    _listAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerAnimation = CurvedAnimation(
      parent: _listAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutQuart),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fabAnimationController.forward();
      _listAnimationController.forward();
    });

    context.read<AddressBloc>().add(LoadAddresses());
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _listAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = _isDesktop();
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 768 && screenSize.width < 1200;

    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: BlocConsumer<AddressBloc, AddressState>(
          listener: _handleStateChanges,
          builder: (context, state) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeader(),
                if (state.isLoading)
                  _buildLoadingSliver()
                else if (state.addresses.isEmpty)
                  _buildEmptySliver()
                else
                  _buildAddressSliver(state, isDesktop, isTablet),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(isDesktop),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: AppConfig.backgroundColor,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: AppConfig.primaryTextColor,
        ),
      ),
      title: Text(
        widget.isSelectionMode ? "Select Address" : "My Addresses",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: AppConfig.primaryTextColor,
          fontSize: 18,
          letterSpacing: 0.3,
        ),
      ),
      centerTitle: false,
      actions:
          widget.isSelectionMode && _hasSelectedAddress()
              ? [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppConfig.gradientColors,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppConfig.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _confirmSelection,
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text("Confirm"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppConfig.primaryButtonTextColor,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ]
              : null,
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: AnimatedBuilder(
        animation: _headerAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 30 * (1 - _headerAnimation.value)),
            child: Opacity(
              opacity: _headerAnimation.value,
              child: Container(
                margin: EdgeInsets.all(_isDesktop() ? 32 : 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppConfig.primaryColor.withOpacity(0.1),
                      AppConfig.primaryColor.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppConfig.primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppConfig.shadowColor,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: AppConfig.gradientColors,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppConfig.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.location_city_rounded,
                        color: AppConfig.primaryButtonTextColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isSelectionMode
                                ? "Choose delivery address"
                                : "Manage your addresses",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppConfig.primaryTextColor,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.isSelectionMode
                                ? "Select where you want your order delivered"
                                : "Add, edit, or remove your saved addresses",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppConfig.primaryTextColor.withOpacity(
                                0.7,
                              ),
                              height: 1.4,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingSliver() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: AppConfig.gradientColors),
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation(
                    AppConfig.primaryButtonTextColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Loading your addresses...",
              style: TextStyle(
                fontSize: 16,
                color: AppConfig.primaryTextColor.withOpacity(0.7),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySliver() {
    return SliverFillRemaining(
      child: AnimatedBuilder(
        animation: _listAnimationController,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.8 + (0.2 * _listAnimationController.value),
            child: Opacity(
              opacity: _listAnimationController.value,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(_isDesktop() ? 64 : 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: _isDesktop() ? 200 : 160,
                        height: _isDesktop() ? 200 : 160,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              AppConfig.primaryColor.withOpacity(0.1),
                              AppConfig.primaryColor.withOpacity(0.05),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_location_alt_outlined,
                          size: _isDesktop() ? 80 : 64,
                          color: AppConfig.primaryColor,
                        ),
                      ),
                      SizedBox(height: _isDesktop() ? 40 : 32),
                      Text(
                        "No addresses saved yet",
                        style: TextStyle(
                          fontSize: _isDesktop() ? 28 : 24,
                          fontWeight: FontWeight.w700,
                          color: AppConfig.primaryTextColor,
                          letterSpacing: 0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Start by adding your home, work, or any other\nfrequently used addresses for quick checkout",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppConfig.primaryTextColor.withOpacity(0.7),
                          height: 1.6,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: _isDesktop() ? 48 : 40),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: AppConfig.gradientColors,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppConfig.primaryColor.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => _showAddressForm(),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text("Add Your First Address"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: AppConfig.primaryButtonTextColor,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                              horizontal: _isDesktop() ? 32 : 24,
                              vertical: _isDesktop() ? 20 : 16,
                            ),
                            textStyle: TextStyle(
                              fontSize: _isDesktop() ? 16 : 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddressSliver(
    AddressState state,
    bool isDesktop,
    bool isTablet,
  ) {
    final padding = EdgeInsets.symmetric(
      horizontal: isDesktop ? 32 : 20,
      vertical: 8,
    );

    return SliverPadding(
      padding: padding,
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final address = state.addresses[index];
          return _buildAnimatedAddressCard(address, state, index);
        }, childCount: state.addresses.length),
      ),
    );
  }

  Widget _buildAnimatedAddressCard(
    AddressModel address,
    AddressState state,
    int index,
  ) {
    final animationDelay = index * 0.1;
    final isSelected =
        widget.isSelectionMode && state.selectedAddress?.id == address.id;

    return AnimatedBuilder(
      animation: _listAnimationController,
      builder: (context, child) {
        final animationValue = Curves.easeOutCubic.transform(
          (_listAnimationController.value - animationDelay).clamp(0.0, 1.0),
        );

        return Transform.translate(
          offset: Offset(0, 50 * (1 - animationValue)),
          child: Transform.scale(
            scale: 0.8 + (0.2 * animationValue),
            child: Opacity(
              opacity: animationValue,
              child: AddressCard(
                address: address,
                isSelected: isSelected,
                onTap: () => _handleAddressTap(address),
                onEdit: () => _showAddressForm(address),
                onDelete: () => _confirmDelete(address.id),
                onSetDefault: () => _setAsDefault(address.id),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton(bool isDesktop) {
    return AnimatedBuilder(
      animation: _fabAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _fabAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppConfig.gradientColors),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppConfig.primaryColor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              onPressed: () => _showAddressForm(),
              backgroundColor: Colors.transparent,
              foregroundColor: AppConfig.primaryButtonTextColor,
              elevation: 0,
              highlightElevation: 0,
              icon: const Icon(Icons.add_rounded),
              label: Text(
                "Add Address",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: isDesktop ? 16 : 14,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, AddressState state) {
    if (state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: AppConfig.primaryButtonTextColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  state.errorMessage!,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppConfig.primaryButtonTextColor,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppConfig.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
          elevation: 8,
        ),
      );
    }

    if (state.isActionSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: AppConfig.primaryButtonTextColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                "Address updated successfully",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppConfig.primaryButtonTextColor,
                ),
              ),
            ],
          ),
          backgroundColor: AppConfig.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(16),
          elevation: 8,
        ),
      );
    }
  }

  void _showAddressForm([AddressModel? address]) {
    if (_isDesktop()) {
      _showAddressDialog(address);
    } else {
      _showAddressBottomSheet(address);
    }
  }

  void _showAddressDialog(AddressModel? address) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 16,
            child: Container(
              width: 600,
              constraints: const BoxConstraints(maxHeight: 700),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppConfig.primaryColor.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          address == null
                              ? Icons.add_location_alt
                              : Icons.edit_location_alt,
                          color: AppConfig.primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            address == null
                                ? 'Add New Address'
                                : 'Edit Address',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppConfig.primaryTextColor,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: AddressForm(
                        address: address,
                        onSave: (newAddress) {
                          _saveAddress(address, newAddress);
                          Navigator.pop(context);
                        },
                        onCancel: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showAddressBottomSheet(AddressModel? address) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder:
          (context) => DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder:
                (context, scrollController) => Container(
                  decoration: BoxDecoration(
                    color: AppConfig.backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppConfig.shadowColor,
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                          color: AppConfig.primaryTextColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Icon(
                              address == null
                                  ? Icons.add_location_alt
                                  : Icons.edit_location_alt,
                              color: AppConfig.primaryColor,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                address == null
                                    ? 'Add New Address'
                                    : 'Edit Address',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: AppConfig.primaryTextColor,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 24,
                            right: 24,
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 24,
                          ),
                          child: AddressForm(
                            address: address,
                            onSave: (newAddress) {
                              _saveAddress(address, newAddress);
                              Navigator.pop(context);
                            },
                            onCancel: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
    );
  }

  void _saveAddress(AddressModel? existingAddress, AddressModel newAddress) {
    if (existingAddress == null) {
      context.read<AddressBloc>().add(AddAddress(newAddress));
    } else {
      context.read<AddressBloc>().add(UpdateAddress(newAddress));
    }
  }

  bool _hasSelectedAddress() {
    final state = context.read<AddressBloc>().state;
    return widget.isSelectionMode && state.selectedAddress != null;
  }

  void _confirmSelection() {
    if (!widget.isSelectionMode) return;
    final selectedAddress = context.read<AddressBloc>().state.selectedAddress;
    if (selectedAddress != null) {
      Navigator.pop(context, selectedAddress);
    }
  }

  void _handleAddressTap(AddressModel address) {
    if (widget.isSelectionMode) {
      context.read<AddressBloc>().add(SelectAddress(address));
    }
  }

  void _setAsDefault(String id) {
    context.read<AddressBloc>().add(SetDefaultAddress(id));
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            icon: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConfig.errorColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: AppConfig.errorColor,
                size: 32,
              ),
            ),
            title: const Text(
              "Delete Address",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: const Text(
              "Are you sure you want to delete this address? This action cannot be undone.",
              style: TextStyle(height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AddressBloc>().add(DeleteAddress(id));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.errorColor,
                  foregroundColor: AppConfig.primaryButtonTextColor,
                ),
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }

  bool _isDesktop() {
    if (kIsWeb) return true;
    return defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;
  }
}
