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
import 'package:demo_app/screens/order_confirmation/components/responsive_layout.dart';
import 'package:demo_app/screens/order_confirmation/components/ecommerce_card.dart';
import 'package:demo_app/screens/order_confirmation/components/ecommerce_payment_selector.dart';
import 'package:demo_app/screens/order_confirmation/components/ecommerce_address_selector.dart';
import 'package:demo_app/screens/order_confirmation/components/order_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with TickerProviderStateMixin {
  final _paymentMethods = [
    {
      'name': 'Credit Card',
      'icon': 'assets/icons/credit_card.png',
      'popular': false,
    },
    {
      'name': 'Debit Card',
      'icon': 'assets/icons/debit_card.png',
      'popular': false,
    },
    {
      'name': 'Cash on Delivery',
      'icon': 'assets/icons/cod.png',
      'popular': true,
    },
    {'name': 'UPI', 'icon': 'assets/icons/upi.png', 'popular': true},
  ];
  String _selectedPaymentMethod = 'Cash on Delivery';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    context.read<OrderBloc>().add(
      LoadOrderDetails(
        cartItems: widget.cartItems,
        totalAmount: widget.totalAmount,
      ),
    );
    context.read<AddressBloc>().add(LoadAddresses());

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const CustomAppBar(
        title: 'Order Confirmation',
        subtitle: 'Review your order details',
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state.isOrderPlaced) {
            _showOrderSuccessDialog(context);
          }
          if (state.errorMessage != null) {
            _showErrorSnackBar(state.errorMessage!);
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return _buildLoadingState();
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: ResponsiveLayout(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 100, 16, 120),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Order Summary with modern design
                        OrderSummaryCard(
                          cartItems: state.cartItems,
                          totalAmount: state.totalAmount,
                        ),

                        const SizedBox(height: 20),

                        // Items Preview
                        _buildItemsPreview(state),

                        const SizedBox(height: 20),

                        // Payment Method
                        EcommerceCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader(
                                'Payment Method',
                                Icons.payment,
                                Colors.blue[600]!,
                              ),
                              const SizedBox(height: 16),
                              EcommercePaymentSelector(
                                paymentMethods: _paymentMethods,
                                selectedMethod: _selectedPaymentMethod,
                                onMethodChanged: (method) {
                                  setState(() {
                                    _selectedPaymentMethod = method;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Delivery Address
                        EcommerceCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader(
                                'Delivery Address',
                                Icons.location_on_rounded,
                                Colors.red[500]!,
                              ),
                              const SizedBox(height: 16),
                              EcommerceAddressSelector(
                                onAddressChange:
                                    () => _navigateToAddressScreen(context),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Delivery Time Estimation
                        _buildDeliveryTime(),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildModernBottomBar(),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppConfig.primaryColor.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppConfig.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Preparing your order...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsPreview(OrderState state) {
    return EcommerceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Your Items (${state.cartItems.length})',
            Icons.shopping_bag_rounded,
            Colors.orange[600]!,
          ),
          const SizedBox(height: 16),

          // Show first 2 items with "View All" option
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.cartItems.length > 2 ? 2 : state.cartItems.length,
            separatorBuilder: (context, index) => const Divider(height: 16),
            itemBuilder: (context, index) {
              final item = state.cartItems[index];
              return _buildCompactItemCard(item);
            },
          ),

          if (state.cartItems.length > 2) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _showAllItemsDialog(state.cartItems),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConfig.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppConfig.primaryColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View ${state.cartItems.length - 2} more items',
                      style: TextStyle(
                        color: AppConfig.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: AppConfig.primaryColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactItemCard(CartItem item) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[100],
          ),
          child:
              item.product.images.isNotEmpty
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.product.images[0],
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Icon(Icons.image, color: Colors.grey[400]),
                    ),
                  )
                  : Icon(Icons.fastfood, color: Colors.grey[400]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.product.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                'Qty: ${item.quantity}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Text(
          'Rs.${(item.product.price * item.quantity).toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppConfig.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryTime() {
    return EcommerceCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.access_time_rounded,
              color: Colors.green[700],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Estimated Delivery',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '25-30 minutes',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Text(
              'Fast',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Total amount row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Amount',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Rs.${widget.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                      if (state.isLoading)
                        Container(
                          padding: const EdgeInsets.all(12),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppConfig.primaryColor,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Place Order Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppConfig.primaryColor,
                          AppConfig.primaryColor.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppConfig.primaryColor.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed:
                          state.isLoading
                              ? null
                              : () => _handlePlaceOrder(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shopping_cart_checkout_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Place Order',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAllItemsDialog(List<CartItem> items) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'All Items (${items.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    separatorBuilder:
                        (context, index) => const Divider(height: 16),
                    itemBuilder:
                        (context, index) => _buildCompactItemCard(items[index]),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _handlePlaceOrder(BuildContext context) {
    final addressState = context.read<AddressBloc>().state;
    final selectedAddress =
        addressState.selectedAddress ??
        (addressState.addresses.isNotEmpty
            ? addressState.addresses.first
            : null);

    if (selectedAddress == null) {
      _showErrorSnackBar('Please select a delivery address');
      return;
    }

    context.read<OrderBloc>().add(
      PlaceOrder(
        paymentMethod: _selectedPaymentMethod,
        deliveryAddress: selectedAddress,
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
              'Thank you for your order. Your order has been placed successfully.',
          onClose: () {
            context.read<CartBloc>().add(ClearAllCart());
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        );
      },
    );
  }
}
