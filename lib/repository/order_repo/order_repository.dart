import 'package:demo_app/models/order_model.dart';
import 'package:demo_app/repository/api_model/api_response.dart';

abstract class OrderRepository {
  // Create a new order
  Future<ApiResponse<OrderModel>> createOrder(OrderModel order);

  // Get all orders for the current user
  Future<ApiResponse<List<OrderModel>>> getUserOrders(String userId);

  // Get a specific order by ID
  Future<ApiResponse<OrderModel>> getOrderById(String orderId);

  // Update order status
  Future<ApiResponse<OrderModel>> updateOrderStatus(
    String orderId,
    String status,
  );

  // Cancel an order
  Future<ApiResponse<OrderModel>> cancelOrder(String orderId);

  // Delete an order (admin only)
  Future<ApiResponse<bool>> deleteOrder(String orderId);
}
