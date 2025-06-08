import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../app_config.dart';
import '../common/status_chip.dart';

class OrderCard extends StatelessWidget {
  final dynamic order;
  final VoidCallback onViewDetails;
  final VoidCallback? onCancel;

  const OrderCard({
    super.key,
    required this.order,
    required this.onViewDetails,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        order.createdAt != null
            ? DateFormat('MMM dd, yyyy').format(order.createdAt!)
            : 'N/A';

    final itemCount =
        order.items != null
            ? (order.items as List).fold<int>(
              0,
              (int sum, dynamic item) => sum + (item.quantity as int? ?? 0),
            )
            : 0;

    final canCancel =
        (order.status == 'Processing' || order.status == 'Pending') &&
        onCancel != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            _buildOrderHeader(context, formattedDate),
            Container(
              color: const Color(0xFFF8F9FB),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildOrderSummary(context, itemCount),
                    const SizedBox(height: 16),
                    _buildActionButtons(context, canCancel),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHeader(BuildContext context, String formattedDate) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppConfig.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.receipt_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order #${order.id != null && order.id!.length > 8 ? order.id!.substring(0, 8) : (order.id ?? 'N/A')}",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF8E8E93),
                  ),
                ),
              ],
            ),
          ),
          StatusChip(
            status: order.status,
            fontSize: 13,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, int itemCount) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppConfig.primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.shopping_bag_outlined,
            size: 20,
            color: AppConfig.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$itemCount item${itemCount != 1 ? 's' : ''}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8E8E93),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "₹${order.totalAmount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppConfig.primaryColor,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, bool canCancel) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: AppConfig.primaryColor.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onViewDetails,
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: Text(
                    "View Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppConfig.primaryColor,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (canCancel) ...[
          const SizedBox(width: 12),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B6B).withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onCancel,
                borderRadius: BorderRadius.circular(16),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF6B6B),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
