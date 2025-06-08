import 'package:demo_app/app_config.dart';
import 'package:demo_app/models/cart_model.dart';
import 'package:demo_app/screens/order_confirmation/components/ecommerce_card.dart';
import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  final List<CartItem> cartItems;
  final double totalAmount;

  const OrderSummaryCard({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 0),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient background
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppConfig.primaryColor.withOpacity(0.1),
                  AppConfig.primaryColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppConfig.primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: AppConfig.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),

          // Summary Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                    'Items',
                    '${cartItems.length}',
                    icon: Icons.shopping_basket_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    'Subtotal',
                    'Rs.${totalAmount.toStringAsFixed(2)}',
                    icon: Icons.calculate_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    'Delivery Fee',
                    'FREE',
                    icon: Icons.delivery_dining,
                    valueColor: Colors.green[600]!,
                    hasOffer: true,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    'Platform Fee',
                    'Rs.5.00',
                    icon: Icons.info_outline,
                    isSmall: true,
                  ),

                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey[300]!,
                          Colors.grey[100]!,
                          Colors.grey[300]!,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildSummaryRow(
                    'Total Amount',
                    'Rs.${(totalAmount + 5).toStringAsFixed(2)}',
                    icon: Icons.payments_rounded,
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ),

          // Savings banner
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[50]!, Colors.green[100]!],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.savings_outlined,
                    color: Colors.green[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You saved Rs.49 on delivery fee!',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Icon(Icons.celebration, color: Colors.green[600], size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    required IconData icon,
    bool isTotal = false,
    bool isSmall = false,
    Color? valueColor,
    bool hasOffer = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: isSmall ? 16 : 18,
          color: isTotal ? AppConfig.primaryColor : Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isSmall ? 13 : (isTotal ? 16 : 15),
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? const Color(0xFF1A1A1A) : Colors.grey[700],
            ),
          ),
        ),
        if (hasOffer) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'OFFER',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.green[700],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          value,
          style: TextStyle(
            fontSize: isSmall ? 13 : (isTotal ? 16 : 15),
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            color:
                valueColor ??
                (isTotal ? AppConfig.primaryColor : const Color(0xFF1A1A1A)),
          ),
        ),
      ],
    );
  }
}
