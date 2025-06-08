import 'package:demo_app/app_config.dart';
import 'package:demo_app/components/base/custom_alert_dialog.dart';
import 'package:demo_app/components/base/custom_appbar.dart';
import 'package:demo_app/components/common/empty_state_widget.dart';
import 'package:demo_app/components/order/order_card.dart';
import 'package:demo_app/screens/order_details/order_details_screen.dart';
import 'package:demo_app/screens/order_history/components/bloc/order_history_bloc.dart';
import 'package:demo_app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderHistoryBloc>()..add(LoadOrderHistory()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: CustomAppBar(title: "My Orders"),
        body: BlocConsumer<OrderHistoryBloc, OrderHistoryState>(
          listener: (context, state) {
            if (state is OrderHistoryError) {
              _showErrorSnackBar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is OrderHistoryLoading) {
              return _buildLoadingState();
            } else if (state is OrderHistoryLoaded) {
              if (state.orders.isEmpty) {
                return EmptyStateWidget(
                  title: "No Orders Yet",
                  subtitle:
                      "Your order history will appear here once you start shopping with us",
                  icon: Icons.shopping_bag_outlined,
                  buttonText: "Start Shopping",
                  onButtonPressed: () => Navigator.pop(context),
                );
              }

              return _buildOrdersList(context, state.orders);
            } else if (state is OrderHistoryError) {
              return EmptyStateWidget(
                title: "Something Went Wrong",
                subtitle: state.message,
                icon: Icons.error_outline_rounded,
                buttonText: "Try Again",
                onButtonPressed: () {
                  context.read<OrderHistoryBloc>().add(LoadOrderHistory());
                },
                primaryColor: const Color(0xFFFF3B30),
              );
            } else {
              return const Center(child: Text("Something went wrong"));
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppConfig.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, List<dynamic> orders) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<OrderHistoryBloc>().add(LoadOrderHistory());
      },
      color: AppConfig.primaryColor,
      backgroundColor: Colors.white,
      strokeWidth: 3,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(
            order: order,
            onViewDetails: () => _navigateToOrderDetails(context, order),
            onCancel:
                (order.status == 'Processing' || order.status == 'Pending')
                    ? () => _showCancelDialog(context, order.id!)
                    : null,
          );
        },
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFF3B30),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _navigateToOrderDetails(BuildContext context, dynamic order) {
    if (order.id != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailsScreen(orderId: order.id!),
        ),
      );
    } else {
      _showErrorSnackBar(context, "Cannot view details: Order ID is missing");
    }
  }

  void _showCancelDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => CustomAlertDialog(
            type: AlertType.confirmation,
            title: "Cancel Order",
            message:
                "Are you sure you want to cancel this order? This action cannot be undone.",
            confirmText: "Yes, Cancel",
            cancelText: "Keep Order",
            onConfirm: () {
              context.read<OrderHistoryBloc>().add(CancelOrderHistory(orderId));
            },
          ),
    );
  }
}
