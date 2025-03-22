import 'package:demo_app/latest/constants.dart';
import 'package:demo_app/latest/models/api_model/user_model.dart';
import 'package:demo_app/latest/repository/api_model/api_response.dart';
import 'package:demo_app/latest/repository/auth_repo/auth_repository.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;

  AuthRepositoryImpl({required this.dio});

  static const authBaseUrl = "$baseUrl/user";

  @override
  Future<ApiResponse<User>> login(String email, String password) async {
    try {
      Response response = await dio.post(
        '$authBaseUrl/login',
        data: {'email': email, 'password': password},
      );

      final responseData = response.data;

      if (response.statusCode == 200) {
        if (responseData['success']) {
          return ApiResponse<User>.fromJson(
            responseData,
            (data) => User.fromJson(data['user']),
          );
        } else {
          throw Exception(
            responseData['message'] ?? 'Failed to complete the request',
          );
        }
      } else if (response.statusCode == 400) {
        throw Exception(responseData['message'] ?? 'Bad Request');
      } else {
        throw Exception('Failed: Server returned an error.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        return ApiResponse<User>.fromJson(
          responseData,
          (data) => User.fromJson(data['user']),
        );
      }
      throw Exception('Failed: DioException: ${e.message}');
    } catch (e) {
      throw Exception('Failed: $e');
    }
  }

  // Get Profile method for the API request
  @override
  Future<ApiResponse<User>> getProfile(String userId) async {
    try {
      Response response = await dio.get('$authBaseUrl/$userId');

      final responseData = response.data;

      if (response.statusCode == 200) {
        if (responseData['success']) {
          return ApiResponse<User>.fromJson(
            responseData,
            (data) => User.fromJson(data['user']),
          );
        } else {
          throw Exception(responseData['message'] ?? 'Failed to fetch profile');
        }
      } else {
        throw Exception('Failed: Server returned an error.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;

        return ApiResponse<User>.fromJson(
          responseData,
          (data) => User.fromJson(data['user']),
        );
      }
      throw Exception('Failed: DioException: ${e.message}');
    } catch (e) {
      throw Exception('Failed: $e');
    }
  }

  // Register method for the API request
  @override
  Future<ApiResponse<User>> register(
    String name,
    String email,
    String mobile,
    String dob,
    String password,
  ) async {
    try {
      Response response = await dio.post(
        '$authBaseUrl/signup',
        data: {'name': name, 'email': email, 'dob': dob, 'password': password},
      );

      final responseData = response.data;

      if (response.statusCode == 201) {
        if (responseData['success']) {
          return ApiResponse<User>.fromJson(
            responseData,
            (data) => User.fromJson(data['user']),
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
        return ApiResponse<User>.fromJson(
          responseData,
          (data) => User.fromJson(data['user']),
        );
      }
      throw Exception('Failed: DioException: ${e.message}');
    } catch (e) {
      throw Exception('Failed: $e');
    }
  }

  @override
  Future forgotPassword(String email) async {
    try {
      // Make sure the URL for forgot password is correct based on your API structure
      final response = await dio.post(
        '$authBaseUrl/forgot-password', // Assuming the endpoint is /forgot-password
        data: {'email': email},
      );
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        return ApiResponse<User>.fromJson(
          responseData,
          (data) => User.fromJson(data['user']),
        );
      }
      throw Exception('Failed: DioException: ${e.message}');
    } catch (e) {
      throw Exception('Failed: $e');
    }
  }
}
