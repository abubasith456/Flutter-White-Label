import 'package:demo_app/app_config.dart';
import 'package:demo_app/components/base/custom_appbar.dart';
import 'package:demo_app/components/base/custom_button.dart';
import 'package:demo_app/components/base/custom_alert_dialog.dart';
import 'package:demo_app/components/base/network_image_with_error.dart';
import 'package:demo_app/models/cart_model.dart';
import 'package:demo_app/repository/address_repository.dart';
import 'package:demo_app/screens/address/components/bloc/adress_bloc.dart';
import 'package:demo_app/screens/cart/components/block/cart_block.dart';
import 'package:demo_app/screens/cart/components/cart_item_card.dart';
import 'package:demo_app/screens/cart/components/cart_summary_card.dart';
import 'package:demo_app/screens/cart/components/empty_cart_widget.dart';
import 'package:demo_app/screens/order_confirmation/bloc/order_bloc.dart';
import 'package:demo_app/screens/order_confirmation/order_confirmation_screen.dart';
import 'package:demo_app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    context.read<CartBloc>().add(LoadCart());
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
      appBar: CustomAppBar(
        title: "Shopping Cart",
        subtitle: "Review your items",
        showActionButton: true,
        actionIcon: Icons.delete_sweep_rounded,
        onAction: () => _showClearCartDialog(),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state.cartItems.isEmpty) {
            // Show success message when cart is cleared
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Cart cleared successfully'),
                  ],
                ),
                backgroundColor: Colors.green[600],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.all(16),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.cartItems.isEmpty) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: EmptyCartWidget(
                onContinueShopping: () => Navigator.pop(context),
              ),
            );
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Cart Summary Header
                  Container(
                    margin: const EdgeInsets.all(16),
                    child: CartSummaryCard(
                      itemCount: state.cartItems.length,
                      totalAmount: _calculateTotal(state.cartItems),
                    ),
                  ),

                  // Cart Items List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = state.cartItems[index];
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300 + (index * 100)),
                          curve: Curves.easeOutBack,
                          child: CartItemCard(
                            cartItem: cartItem,
                            onQuantityChanged:
                                (newQuantity) =>
                                    _updateQuantity(cartItem, newQuantity),
                            onRemove: () => _removeItem(cartItem),
                          ),
                        );
                      },
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

  Widget _buildModernBottomBar() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state.cartItems.isEmpty) return const SizedBox.shrink();

        final totalAmount = _calculateTotal(state.cartItems);

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pricing breakdown
                  _buildPricingBreakdown(state.cartItems, totalAmount),

                  const SizedBox(height: 16),

                  // Checkout Button
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
                          () => _navigateToOrderConfirmation(
                            context,
                            state.cartItems,
                            totalAmount,
                          ),
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
                            'Proceed to Checkout',
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
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPricingBreakdown(List<CartItem> cartItems, double totalAmount) {
    final subtotal = totalAmount;
    final deliveryFee = 50.0; // Fixed delivery fee
    final discount = 0.0; // Could be calculated based on offers
    final finalTotal = subtotal + deliveryFee - discount;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildPriceRow('Subtotal', 'Rs.${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildPriceRow(
            'Delivery Fee',
            'Rs.${deliveryFee.toStringAsFixed(2)}',
          ),
          if (discount > 0) ...[
            const SizedBox(height: 8),
            _buildPriceRow(
              'Discount',
              '-Rs.${discount.toStringAsFixed(2)}',
              color: Colors.green[600],
            ),
          ],
          const Divider(height: 20),
          _buildPriceRow(
            'Total',
            'Rs.${finalTotal.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String amount, {
    Color? color,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: color ?? (isTotal ? Colors.black : Colors.grey[600]),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color: color ?? (isTotal ? AppConfig.primaryColor : Colors.black),
          ),
        ),
      ],
    );
  }

  double _calculateTotal(List<CartItem> cartItems) {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  void _updateQuantity(CartItem cartItem, int newQuantity) {
    if (newQuantity > 0) {
      context.read<CartBloc>().add(
        UpdateQuantity(
          productId: cartItem.product.id,
          newQuantity: newQuantity,
        ),
      );
    } else {
      _removeItem(cartItem);
    }
  }

  void _removeItem(CartItem cartItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          type: AlertType.warning,
          title: 'Remove Item',
          message:
              'Are you sure you want to remove "${cartItem.product.name}" from your cart?',
          confirmText: 'Remove',
          cancelText: 'Cancel',
          onConfirm: () {
            context.read<CartBloc>().add(RemoveFromCart(cartItem.product));

            // Show success snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Item removed from cart'),
                  ],
                ),
                backgroundColor: Colors.orange[600],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.all(16),
                action: SnackBarAction(
                  label: 'UNDO',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<CartBloc>().add(AddToCart(cartItem.product));
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showClearCartDialog() {
    final cartState = context.read<CartBloc>().state;
    if (cartState.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info, color: Colors.white),
              SizedBox(width: 8),
              Text('Your cart is already empty'),
            ],
          ),
          backgroundColor: Colors.blue[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(16),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          type: AlertType.warning,
          title: 'Clear Cart',
          message:
              'Are you sure you want to remove all items from your cart? This action cannot be undone.',
          confirmText: 'Clear All',
          cancelText: 'Cancel',
          onConfirm: () {
            context.read<CartBloc>().add(ClearAllCart());
          },
        );
      },
    );
  }

  Future<void> _navigateToOrderConfirmation(
    BuildContext context,
    List<CartItem> cartItems,
    double totalAmount,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => sl<OrderBloc>()),
                BlocProvider(
                  create: (context) => AddressBloc(AddressRepository(prefs)),
                ),
              ],
              child: OrderConfirmationScreen(
                cartItems: cartItems,
                totalAmount: totalAmount + 50.0, // Including delivery fee
              ),
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
