import 'package:demo_app/app_config.dart';
import 'package:demo_app/constants.dart';
import 'package:demo_app/models/order_model.dart';
import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  final OrderModel order;

  const OrderSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    double subtotal = order.items.fold(
      0,
      (sum, item) => sum + (item.priceAtPurchase * item.quantity),
    );
    double shipping = order.totalAmount - subtotal;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppConfig.primaryColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppConfig.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.receipt_outlined,
                    color: AppConfig.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Order Summary",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppConfig.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConfig.primaryColor.withOpacity(0.02),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppConfig.primaryColor.withOpacity(0.1),
                ),
              ),
              child: Column(
                children: [
                  _summaryRow("Subtotal", "₹${subtotal.toStringAsFixed(2)}"),
                  const SizedBox(height: 12),
                  _summaryRow("Shipping", "₹${shipping.toStringAsFixed(2)}"),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppConfig.primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: _summaryRow(
                      "Total Amount",
                      "₹${order.totalAmount.toStringAsFixed(2)}",
                      isTotal: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 16 : 14,
            color: isTotal ? AppConfig.primaryColor : blackColor60,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? 16 : 14,
            color: isTotal ? AppConfig.primaryColor : blackColor,
          ),
        ),
      ],
    );
  }
}
