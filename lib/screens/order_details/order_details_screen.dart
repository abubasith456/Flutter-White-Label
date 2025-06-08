import 'package:demo_app/components/base/custom_appbar.dart';
import 'package:demo_app/constants.dart';
import 'package:demo_app/models/order_model.dart';
import 'package:demo_app/screens/order_details/components/order_details_bloc.dart';
import 'package:demo_app/screens/order_details/components/order_header_card.dart';
import 'package:demo_app/screens/order_details/components/order_items_card.dart';
import 'package:demo_app/screens/order_details/components/shipping_address_card.dart';
import 'package:demo_app/screens/order_details/components/order_summary_card.dart';
import 'package:demo_app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_app/app_config.dart';

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
        backgroundColor: const Color(0xFFF8FAFF),
        appBar: CustomAppBar(title: "Order Details"),
        body: BlocBuilder<OrderDetailsBloc, OrderDetailsState>(
          builder: (context, state) {
            if (state is OrderDetailsLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppConfig.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Loading order details...",
                      style: TextStyle(
                        color: AppConfig.primaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is OrderDetailsError) {
              return _buildErrorState(context, state.message);
            } else if (state is OrderDetailsLoaded) {
              return _OrderDetailsContent(order: state.order);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8FAFF), Color(0xFFE8F0FE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: errorColor.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: errorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: errorColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Oops! Something went wrong",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: blackColor60, fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<OrderDetailsBloc>().add(
                            LoadOrderDetails(orderId: orderId),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConfig.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Try Again",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
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
  }
}

class _OrderDetailsContent extends StatelessWidget {
  final OrderModel order;

  const _OrderDetailsContent({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8FAFF), Color(0xFFE8F0FE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            OrderHeaderCard(order: order),
            OrderItemsCard(items: order.items),
            ShippingAddressCard(address: order.shippingAddress),
            OrderSummaryCard(order: order),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
