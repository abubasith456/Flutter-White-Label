import 'package:demo_app/latest/screens/order_history/components/bloc/order_history_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderBloc()..add(LoadOrders()),
      child: Scaffold(
        appBar: AppBar(title: Text("Order History")),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is OrderLoaded) {
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text("Order #${order.id}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Status: ${order.status}"),
                          Text("Date: ${order.date}"),
                          Text("Total: \$${order.total.toStringAsFixed(2)}"),
                          Text("Items: ${order.items.join(", ")}"),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Handle Order Details Navigation
                      },
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text("Failed to load orders"));
            }
          },
        ),
      ),
    );
  }
}
