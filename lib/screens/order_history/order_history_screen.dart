import 'package:demo_app/components/base/custom_appbar.dart';
import 'package:demo_app/constants.dart';
import 'package:demo_app/screens/order_details/order_details_screen.dart';
import 'package:demo_app/screens/order_history/components/bloc/order_history_bloc.dart';
import 'package:demo_app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderHistoryBloc>()..add(LoadOrderHistory()),
      child: Scaffold(
        appBar: CustomAppBar(title: "My Orders"),
        body: BlocConsumer<OrderHistoryBloc, OrderHistoryState>(
          listener: (context, state) {
            if (state is OrderHistoryError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: errorColor,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is OrderHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrderHistoryLoaded) {
              if (state.orders.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 64,
                        color: greyColor,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "No orders yet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Your order history will appear here",
                        style: TextStyle(color: greyColor),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<OrderHistoryBloc>().add(LoadOrderHistory());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    final order = state.orders[index];
                    final formattedDate =
                        order.createdAt != null
                            ? DateFormat(
                              'MMM dd, yyyy',
                            ).format(order.createdAt!)
                            : 'N/A';

                    // Get total items count
                    final itemCount = order.items.fold<int>(
                      0,
                      (sum, item) => sum + item.quantity,
                    );

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Order #${order.id != null && order.id!.length > 8 ? order.id!.substring(0, 8) : (order.id ?? 'N/A')}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                _buildStatusChip(order.status),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Date: $formattedDate",
                                  style: const TextStyle(color: blackColor60),
                                ),
                                Text(
                                  "Items: $itemCount",
                                  style: const TextStyle(color: blackColor60),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total: ₹${order.totalAmount.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (order.status == 'Processing' ||
                                    order.status == 'Pending')
                                  TextButton(
                                    onPressed: () {
                                      if (order.id != null) {
                                        _showCancelDialog(context, order.id!);
                                      }
                                    },
                                    child: const Text(
                                      "Cancel Order",
                                      style: TextStyle(color: errorColor),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () {
                                // Navigate to order details
                                if (order.id != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => OrderDetailsScreen(
                                            orderId: order.id!,
                                          ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Cannot view details: Order ID is missing",
                                      ),
                                      backgroundColor: errorColor,
                                    ),
                                  );
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 40),
                                side: const BorderSide(color: primaryColor),
                              ),
                              child: const Text("View Details"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (state is OrderHistoryError) {
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
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: blackColor60),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<OrderHistoryBloc>().add(
                          LoadOrderHistory(),
                        );
                      },
                      child: const Text("Try Again"),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text("Something went wrong"));
            }
          },
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text("Cancel Order"),
            content: const Text(
              "Are you sure you want to cancel this order? This action cannot be undone.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<OrderHistoryBloc>().add(
                    CancelOrderHistory(orderId),
                  );
                },
                child: const Text(
                  "Yes, Cancel",
                  style: TextStyle(color: errorColor),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'delivered':
        chipColor = successColor.withOpacity(0.2);
        textColor = successColor;
        break;
      case 'shipped':
        chipColor = primaryColor.withOpacity(0.2);
        textColor = primaryColor;
        break;
      case 'processing':
        chipColor = warningColor.withOpacity(0.2);
        textColor = warningColor;
        break;
      case 'cancelled':
        chipColor = errorColor.withOpacity(0.2);
        textColor = errorColor;
        break;
      default:
        chipColor = greyColor.withOpacity(0.2);
        textColor = greyColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
