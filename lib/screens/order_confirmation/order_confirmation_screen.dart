import 'package:demo_app/app_config.dart';
import 'package:demo_app/components/base/custom_alert_dialog.dart';
import 'package:demo_app/components/base/custom_appbar.dart';
import 'package:demo_app/components/base/custom_button.dart';
import 'package:demo_app/models/address_model.dart';
import 'package:demo_app/models/cart_model.dart';
import 'package:demo_app/repository/address_repository.dart';
import 'package:demo_app/route/screen_export.dart';
import 'package:demo_app/screens/address/address_screen.dart';
import 'package:demo_app/screens/address/components/bloc/adress_bloc.dart';
import 'package:demo_app/screens/cart/components/block/cart_block.dart';
import 'package:demo_app/screens/order_confirmation/bloc/order_bloc.dart';
import 'package:demo_app/screens/order_confirmation/components/order_item_card.dart';
import 'package:demo_app/screens/order_confirmation/components/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderConfirmationScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalAmount;

  const OrderConfirmationScreen({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final _paymentMethods = [
    'Credit Card',
    'Debit Card',
    'Cash on Delivery',
    'UPI',
  ];
  String _selectedPaymentMethod = 'Cash on Delivery';

  // Sample addresses - in a real app, these would come from a user's saved addresses
  final _addresses = [
    '123 Main St, Apartment 4B, New York, NY 10001',
    '456 Park Ave, Suite 201, Boston, MA 02108',
  ];
  String _selectedAddress = '123 Main St, Apartment 4B, New York, NY 10001';

  @override
  void initState() {
    super.initState();
    // Initialize the bloc with cart items
    context.read<OrderBloc>().add(
      LoadOrderDetails(
        cartItems: widget.cartItems,
        totalAmount: widget.totalAmount,
      ),
    );

    // Load addresses
    context.read<AddressBloc>().add(LoadAddresses());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Order Confirmation'),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state.isOrderPlaced) {
            // Show success dialog when order is placed
            _showOrderSuccessDialog(context);
          }

          if (state.errorMessage != null) {
            // Show error snackbar if there's an error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary Section
                const SectionTitle(title: 'Order Summary'),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Items:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${state.cartItems.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Rs.${state.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppConfig.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Order Items Section
                const SectionTitle(title: 'Order Items'),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = state.cartItems[index];
                    return OrderItemCard(cartItem: item);
                  },
                ),

                const SizedBox(height: 24),

                // Payment Method Section
                const SectionTitle(title: 'Payment Method'),
                const SizedBox(height: 8),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select Payment Method',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          value: _selectedPaymentMethod,
                          items:
                              _paymentMethods.map((method) {
                                return DropdownMenuItem(
                                  value: method,
                                  child: Text(method),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Delivery Address Section
                const SectionTitle(title: 'Delivery Address'),
                const SizedBox(height: 8),
                BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, addressState) {
                    if (addressState.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (addressState.addresses.isEmpty) {
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'No addresses found',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ElevatedButton.icon(
                                onPressed:
                                    () => _navigateToAddressScreen(context),
                                icon: const Icon(Icons.add),
                                label: const Text('Add New Address'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppConfig.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Display the selected address
                    final selectedAddress =
                        addressState.selectedAddress ??
                        addressState.addresses.first;

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedAddress.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (selectedAddress.isPrimary)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppConfig.primaryColor.withOpacity(
                                        0.1,
                                      ),
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
                            const SizedBox(height: 8),
                            Text(
                              selectedAddress.fullAddress,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              selectedAddress.phone,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed:
                                  () => _navigateToAddressScreen(context),
                              icon: const Icon(Icons.edit_location_alt),
                              label: const Text('Change Address'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppConfig.primaryColor,
                                side: BorderSide(color: AppConfig.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              text: 'Place Order - Rs.${widget.totalAmount.toStringAsFixed(2)}',
              onPressed:
                  state.isLoading
                      ? () => {}
                      : () {
                        // Get the selected address from the AddressBloc
                        final addressState = context.read<AddressBloc>().state;
                        final selectedAddress =
                            addressState.selectedAddress ??
                            (addressState.addresses.isNotEmpty
                                ? addressState.addresses.first
                                : null);

                        if (selectedAddress == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a delivery address'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        context.read<OrderBloc>().add(
                          PlaceOrder(
                            paymentMethod: _selectedPaymentMethod,
                            deliveryAddress: selectedAddress,
                          ),
                        );
                      },
              isGradient: true,
              height: 60,
            ),
          );
        },
      ),
    );
  }

  Future<void> _navigateToAddressScreen(BuildContext context) async {
    final result = await Navigator.pushNamed(
      context,
      addressScreenRouter,
      arguments: {'isSelectionMode': true},
    );

    if (result != null && result is AddressModel) {
      context.read<AddressBloc>().add(SelectAddress(result));
    }
  }

  void _showOrderSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          type: AlertType.success,
          title: 'Order Placed Successfully!',
          message:
              '''Thank you for your order. Your order has been placed successfully.''',
          onClose: () {
            // Clear cart and navigate back to home
            context.read<CartBloc>().add(ClearAllCart());
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        );
      },
    );
  }
}
