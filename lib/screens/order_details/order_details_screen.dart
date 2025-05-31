import 'package:demo_app/components/base/custom_appbar.dart';
import 'package:demo_app/constants.dart';
import 'package:demo_app/models/order_model.dart';
import 'package:demo_app/repository/api_model/api_response.dart';
import 'package:demo_app/repository/order_repo/order_repository.dart';
import 'package:demo_app/screens/order_details/components/order_details_bloc.dart';
import 'package:demo_app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:demo_app/app_config.dart'; // <-- Add this import

// order_details_screen.dart
class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<OrderDetailsBloc>()..add(LoadOrderDetails(orderId: orderId)),
      child: Scaffold(
        appBar: CustomAppBar(title: "Order Details"),
        body: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
          builder: (context, state) {
            if (state is OrderDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrderDetailsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: errorColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Error: ${state.message}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: blackColor60),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<OrderDetailsBloc>().add(
                          LoadOrderDetails(orderId: orderId),
                        );
                      },
                      child: const Text("Try Again"),
                    ),
                  ],
                ),
              );
            } else if (state is OrderDetailsLoaded) {
              return _OrderDetailsContent(order: state.order);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _OrderDetailsContent extends StatelessWidget {
  final OrderModel order;

  const _OrderDetailsContent({required this.order});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        order.createdAt != null
            ? DateFormat('MMM dd, yyyy - hh:mm a').format(order.createdAt)
            : 'N/A';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8FAFF), Color(0xFFE8F0FE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(order, formattedDate),
            const SizedBox(height: 24),
            _sectionTitle(Icons.shopping_bag, "Items"),
            _buildOrderItems(order),
            const SizedBox(height: 24),
            _sectionTitle(Icons.location_on, "Shipping Address"),
            _buildShippingAddress(order.shippingAddress),
            const SizedBox(height: 24),
            _sectionTitle(Icons.receipt_long, "Order Summary"),
            _buildOrderSummary(order),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Row(
        children: [
          Icon(icon, color: AppConfig.primaryColor, size: 20), // changed
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppConfig.primaryColor, // changed
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHeader(OrderModel order, String formattedDate) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: AppConfig.primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt, color: AppConfig.primaryColor, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Order #${order.id != null && order.id!.length > 8 ? order.id!.substring(0, 8) : (order.id ?? 'N/A')}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                _buildStatusChip(order.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: blackColor60),
                const SizedBox(width: 6),
                Text(
                  "Placed on: $formattedDate",
                  style: const TextStyle(color: blackColor60, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.payment, size: 16, color: blackColor60),
                const SizedBox(width: 6),
                Text(
                  "Payment: ${order.paymentStatus}",
                  style: TextStyle(
                    color:
                        order.paymentStatus.toLowerCase() == 'paid'
                            ? successColor
                            : warningColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingAddress(ShippingAddress address) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.home,
              color: AppConfig.primaryColor,
              size: 28,
            ), // changed
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.fullName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address.mobile,
                    style: const TextStyle(color: blackColor60),
                  ),
                  const SizedBox(height: 4),
                  Text(address.addressLine1),
                  if (address.addressLine2.isNotEmpty) ...[
                    Text(address.addressLine2),
                  ],
                  Text(
                    "${address.city}, ${address.state} ${address.postalCode}",
                  ),
                  Text(address.country),
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
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 16,
            color: isTotal ? AppConfig.primaryColor : Colors.black, // changed
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 18 : 16,
            color: isTotal ? AppConfig.primaryColor : Colors.black, // changed
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'delivered':
        chipColor = successColor.withOpacity(0.15);
        textColor = successColor;
        break;
      case 'shipped':
        chipColor = AppConfig.primaryColor.withOpacity(0.15); // changed
        textColor = AppConfig.primaryColor; // changed
        break;
      case 'processing':
        chipColor = warningColor.withOpacity(0.15);
        textColor = warningColor;
        break;
      case 'cancelled':
        chipColor = errorColor.withOpacity(0.15);
        textColor = errorColor;
        break;
      default:
        chipColor = greyColor.withOpacity(0.15);
        textColor = greyColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: textColor.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildOrderItems(OrderModel order) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children:
              order.items.map((item) {
                return Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 0,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 56,
                          height: 56,
                          color: greyColor.withOpacity(0.15),
                          child:
                              item.productImages != null &&
                                      item.productImages!.isNotEmpty
                                  ? Image.network(
                                    item.productImages![0],
                                    fit: BoxFit.cover,
                                  )
                                  : const Icon(
                                    Icons.image,
                                    color: greyColor,
                                    size: 32,
                                  ),
                        ),
                      ),
                      title: Text(
                        item.productName ?? "Product ID: ${item.productId}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.sizeLabel != null &&
                              item.sizeLabel!.isNotEmpty)
                            Text(
                              "Size: ${item.sizeLabel}",
                              style: const TextStyle(color: blackColor60),
                            ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                "₹${item.priceAtPurchase.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                "Qty: ${item.quantity}",
                                style: const TextStyle(color: blackColor60),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (order.items.last != item) const Divider(height: 1),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(OrderModel order) {
    double subtotal = order.items.fold(
      0,
      (sum, item) => sum + (item.priceAtPurchase * item.quantity),
    );
    double shipping = order.totalAmount - subtotal;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _summaryRow("Subtotal", "₹${subtotal.toStringAsFixed(2)}"),
            const SizedBox(height: 8),
            _summaryRow("Shipping", "₹${shipping.toStringAsFixed(2)}"),
            const Divider(height: 24),
            _summaryRow(
              "Total",
              "₹${order.totalAmount.toStringAsFixed(2)}",
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }
}
