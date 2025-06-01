import 'package:demo_app/constants.dart';
import 'package:demo_app/models/api_model/user_model.dart';
import 'package:demo_app/repository/api_model/api_response.dart';
import 'package:demo_app/repository/auth_repo/auth_repository.dart';
import 'package:dio/dio.dart';
import 'dart:io';

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
        if (e.response!.statusCode == 500) {
          throw Exception('Server error: Please try again later');
        }
        throw Exception(
          responseData['message'] ??
              'Request failed: ${e.response!.statusCode}',
        );
      }
      throw Exception('Network error: ${e.message}');
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
        if (e.response!.statusCode == 500) {
          throw Exception('Server error: Please try again later');
        }
        throw Exception(
          responseData['message'] ??
              'Request failed: ${e.response!.statusCode}',
        );
      }
      throw Exception('Network error: ${e.message}');
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
        if (e.response!.statusCode == 500) {
          throw Exception('Server error: Please try again later');
        }
        throw Exception(
          responseData['message'] ??
              'Request failed: ${e.response!.statusCode}',
        );
      }
      throw Exception('Network error: ${e.message}');
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
        if (e.response!.statusCode == 500) {
          throw Exception('Server error: Please try again later');
        }
        throw Exception(
          responseData['message'] ??
              'Request failed: ${e.response!.statusCode}',
        );
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed: $e');
    }
  }

  @override
  Future<ApiResponse<User>> updateProfile(
    String userId,
    String name,
    String dob,
    String mobile,
    String? profilePic,
  ) async {
    var formData = FormData();
    formData.fields.addAll([
      MapEntry('name', name),
      MapEntry('dob', dob),
      MapEntry('mobile', mobile),
    ]);

    print("Profile Pic: $profilePic");
    if (profilePic != null && profilePic.isNotEmpty) {
      // Check if file exists before adding
      if (await File(profilePic).exists()) {
        formData.files.add(
          MapEntry(
            'profilePic',
            await MultipartFile.fromFile(
              profilePic,
              filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ),
          ),
        );
      }
    }

    print("FormData: ${formData.boundaryName}");

    try {
      final response = await dio.put(
        '$authBaseUrl/$userId', // Assuming the endpoint is /forgot-password
        data: formData,
      );

      final responseData = response.data;

      print("1UPDATE: $responseData");

      if (response.statusCode == 200) {
        if (responseData['success']) {
          print("2UPDATE: success");
          return ApiResponse<User>.fromJson(
            responseData,
            (data) => User.fromJson(data['user']),
          );
        } else {
          throw Exception(responseData['message'] ?? 'Failed to fetch profile');
        }
      } else {
        print("Failed: Server returned an error.");
        throw Exception('Failed: Server returned an error.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        if (e.response!.statusCode == 500) {
          throw Exception('Server error: Please try again later');
        }
        throw Exception(
          responseData['message'] ??
              'Request failed: ${e.response!.statusCode}',
        );
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print("Except: $e");
      throw Exception('Failed: $e');
    }
  }

  @override
  Future<ApiResponse<User>> updateFcmToken(
    String userId,
    String fcmToken,
  ) async {
    try {
      Response response = await dio.post(
        '$authBaseUrl/update-fcm-token',
        data: {'userId': userId, 'fcmToken': fcmToken},
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
            responseData['message'] ?? 'Failed to update FCM token',
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
}
