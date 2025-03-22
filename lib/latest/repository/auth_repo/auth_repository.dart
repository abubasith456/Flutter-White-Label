import 'package:demo_app/latest/models/api_model/user_model.dart';
import 'package:demo_app/latest/repository/api_model/api_response.dart';

abstract class AuthRepository {
  Future<ApiResponse<User>> login(String email, String password);
  Future<ApiResponse<User>> getProfile(String userId);
  Future<ApiResponse<User>> register(
    String name,
    String email,
    String mobile,
    String dob,
    String password,
  );
  Future forgotPassword(String email);
  Future<ApiResponse<User>> updateProfile(
    String userId,
    String name,
    String dob,
    String image,
  );
}
