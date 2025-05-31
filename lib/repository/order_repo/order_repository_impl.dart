import 'package:demo_app/constants.dart';
import 'package:demo_app/models/order_model.dart';
import 'package:demo_app/repository/api_model/api_response.dart';
import 'package:demo_app/repository/order_repo/order_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepositoryImpl implements OrderRepository {
  final Dio dio;
  final SharedPreferences prefs;

  OrderRepositoryImpl({required this.dio, required this.prefs});

  static const orderBaseUrl = "$baseUrl/orders";

  // Get auth token from shared preferences
  String? get _authToken => prefs.getString('authToken');

  // Get user ID from shared preferences
  String? get _userId => prefs.getString('userId');

  // Get auth headers
  Map<String, dynamic> get _authHeaders => {
    'Authorization': 'Bearer $_authToken',
  };

  // Create a new order
  @override
  Future<ApiResponse<OrderModel>> createOrder(OrderModel order) async {
    try {
      Response response = await dio.post(
        orderBaseUrl,
        data: order.toJson(),
        options: Options(headers: _authHeaders),
      );

      final responseData = response.data;

      if (response.statusCode == 201) {
        if (responseData['success']) {
          var orderData = responseData['data']['order'];
          var order = OrderModel.fromJson(Map<String, dynamic>.from(orderData));

          return ApiResponse<OrderModel>(
            success: responseData['success'],
            message: responseData['message'] ?? 'Order created successfully',
            data: order,
          );
        } else {
          throw Exception(
            responseData['message'] ?? 'Failed to complete the request',
          );
        }
      } else {
        throw Exception('Failed: Server returned an error.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        throw Exception(
          responseData['message'] ?? 'Failed to complete the request',
        );
      }
      throw Exception('Failed: DioException: ${e.message}');
    } catch (e) {
      throw Exception('Failed: $e');
    }
  }

  // Get all orders for the current user
  @override
  Future<ApiResponse<List<OrderModel>>> getUserOrders(String userId) async {
    try {
      Response response = await dio.get('$orderBaseUrl/user/$userId');
      final responseData = response.data;
      if (response.statusCode == 200) {
        if (responseData['success']) {
          List<OrderModel> orders = [];

          // Handle case where 'order' is a single object (not a list)
          if (responseData['data'] != null &&
              responseData['data']['orders'] != null) {
            var ordersData = responseData['data']['orders'];

            if (ordersData is List) {
              orders =
                  ordersData
                      .map(
                        (item) => OrderModel.fromJson(
                          Map<String, dynamic>.from(item),
                        ),
                      )
                      .toList();
            } else if (ordersData is Map) {
              orders = [
                OrderModel.fromJson(Map<String, dynamic>.from(ordersData)),
              ];
            }
          }

          var result = ApiResponse<List<OrderModel>>(
            success: responseData['success'],
            message: responseData['message'] ?? 'Orders loaded successfully',
            data: orders,
          );

          return result;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to load orders');
        }
      } else {
        throw Exception('Failed: Server returned an error.');
      }
    } on DioException catch (e) {
      print("DioException: $e");
      if (e.response != null) {
        final responseData = e.response!.data;
        throw Exception(
          responseData['message'] ?? 'Failed to complete the request',
        );
      }
      throw Exception('Failed: DioException: ${e.message}');
    } catch (e) {
      print("Error in getUserOrders: $e");
      throw Exception('Failed: $e');
    }
  }

  // Get a specific order by ID
  @override
  Future<ApiResponse<OrderModel>> getOrderById(String orderId) async {
    try {
      Response response = await dio.get(
        '$orderBaseUrl/$orderId',
        options: Options(headers: _authHeaders),
      );

      final responseData = response.data;

      if (response.statusCode == 200) {
        if (responseData['success']) {
          var orderData = responseData['data']['order'];
          var order = OrderModel.fromJson(Map<String, dynamic>.from(orderData));

          return ApiResponse<OrderModel>(
            success: responseData['success'],
            message: responseData['message'] ?? 'Order loaded successfully',
            data: order,
          );
        } else {
          throw Exception(responseData['message'] ?? 'Failed to load order');
        }
      } else {
        throw Exception('Failed: Server returned an error.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        throw Exception(
          responseData['message'] ?? 'Failed to complete the request',
        );
      }
      throw Exception('Failed: DioException: ${e.message}');
    } catch (e) {
      throw Exception('Failed: $e');
    }
  }

  // Update order status
  @override
  Future<ApiResponse<OrderModel>> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    try {
      Response response = await dio.put(
        '$orderBaseUrl/$orderId',
        data: {'status': status},
        options: Options(headers: _authHeaders),
      );

      final responseData = response.data;

      if (response.statusCode == 200) {
        if (responseData['success']) {
          var orderData = responseData['data']['order'];
          var order = OrderModel.fromJson(Map<String, dynamic>.from(orderData));

          return ApiResponse<OrderModel>(
            success: responseData['success'],
            message: responseData['message'] ?? 'Order updated successfully',
            data: order,
          );
        } else {
          throw Exception(responseData['message'] ?? 'Failed to update order');
        }
      } else {
        throw Exception('Failed: Server returned an error.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        throw Exception(
          responseData['message'] ?? 'Failed to complete the request',
        );
      }
      throw Exception('Failed: DioException: ${e.message}');
    } catch (e) {
      throw Exception('Failed: $e');
    }
  }

  // Cancel an order
  @override
  Future<ApiResponse<OrderModel>> cancelOrder(String orderId) async {
    try {
      // Using the PUT endpoint with status update to "Cancelled"
      Response response = await dio.put(
        '$orderBaseUrl/$orderId',
        data: {'status': 'Cancelled'},
        options: Options(headers: _authHeaders),
      );

      final responseData = response.data;

      if (response.statusCode == 200) {
        if (responseData['success']) {
          var orderData = responseData['data']['order'];
          var order = OrderModel.fromJson(Map<String, dynamic>.from(orderData));

          return ApiResponse<OrderModel>(
            success: responseData['success'],
            message: responseData['message'] ?? 'Order cancelled successfully',
            data: order,
          );
        } else {
          throw Exception(responseData['message'] ?? 'Failed to cancel order');
        }
      } else {
        throw Exception('Failed: Server returned an error.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        throw Exception(
          responseData['message'] ?? 'Failed to complete the request',
        );
      }
      throw Exception('Failed: DioException: ${e.message}');
    } catch (e) {
      throw Exception('Failed: $e');
    }
  }

  // Delete an order (admin only)
  @override
  Future<ApiResponse<bool>> deleteOrder(String orderId) async {
    try {
      Response response = await dio.delete(
        '$orderBaseUrl/$orderId',
        options: Options(headers: _authHeaders),
      );

      final responseData = response.data;

      if (response.statusCode == 200) {
        if (responseData['success']) {
          return ApiResponse<bool>(
            success: true,
            message: responseData['message'] ?? 'Order deleted successfully',
            data: true,
          );
        } else {
          throw Exception(responseData['message'] ?? 'Failed to delete order');
        }
      } else {
        throw Exception('Failed: Server returned an error.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        throw Exception(
          responseData['message'] ?? 'Failed to complete the request',
        );
      }
      throw Exception('Failed: DioException: ${e.message}');
    } catch (e) {
      throw Exception('Failed: $e');
    }
  }
}
