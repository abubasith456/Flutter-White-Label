import 'package:demo_app/latest/constants.dart';
import 'package:demo_app/latest/models/api_model/banner_model.dart';
import 'package:demo_app/latest/models/api_model/category_model.dart';
import 'package:demo_app/latest/models/api_model/product_model.dart'; // Assuming this is the model for Categories
import 'package:demo_app/latest/repository/api_model/api_response.dart';
import 'package:demo_app/latest/repository/products_repo/products_repository.dart';
import 'package:dio/dio.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final Dio dio;

  // Constructor to inject Dio
  ProductsRepositoryImpl({required this.dio});

  static const String productsBaseUrl = baseUrl; // Base URL for products

  @override
  Future<ApiResponse<List<HomeBanner>>> getBanners() async {
    try {
      Response response = await dio.get(
        '$productsBaseUrl/banners',
      ); // Replace with actual endpoint
      final responseData = response.data;
      print(responseData);
      if (response.statusCode == 200) {
        if (responseData['success']) {
          // Extract the list of banners from the response
          List<HomeBanner> banners =
              (responseData['data']['banners'] as List)
                  .map((banner) => HomeBanner.fromJson(banner))
                  .toList();

          return ApiResponse<List<HomeBanner>>.fromJson(
            responseData,
            (data) => banners,
          );
        } else {
          throw Exception(responseData['message'] ?? 'Failed to load banners');
        }
      } else {
        throw Exception('Failed: Server returned an error.');
      }
    } on DioException catch (e) {
      print("DioException: $e");
      if (e.response != null) {
        final responseData = e.response!.data;
        return throw Exception(
          responseData['message'] ?? 'Failed to complete the request',
        );
      }
      throw Exception('Failed: DioException: ${e.message}');
    } catch (e) {
      throw Exception('Failed: $e');
    }
  }

  @override
  Future<ApiResponse<List<Category>>> getCategories() async {
    try {
      Response response = await dio.get(
        '$productsBaseUrl/categories',
      ); // Replace with actual endpoint
      final responseData = response.data;

      if (response.statusCode == 200) {
        if (responseData['success']) {
          List<Category> category =
              (responseData['data']['categories'] as List)
                  .map((banner) => Category.fromJson(banner))
                  .toList();
          return ApiResponse<List<Category>>.fromJson(
            responseData,
            (data) => category,
          );
        } else {
          throw Exception(
            responseData['message'] ?? 'Failed to load categories',
          );
        }
      } else {
        throw Exception('Failed: Server returned an error.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        return throw Exception(
          responseData['message'] ?? 'Failed to complete the request',
        );
      }
      throw Exception('Failed: DioException: ${e.message}');
    } catch (e) {
      throw Exception('Failed: $e');
    }
  }

  @override
  Future<ApiResponse<List<Product>>> getProducts() async {
    try {
      Response response = await dio.get(
        '$productsBaseUrl/products',
      ); // Replace with actual endpoint
      final responseData = response.data;

      if (response.statusCode == 200) {
        if (responseData['success']) {
          List<Product> products =
              (responseData['data']['products'] as List)
                  .map((banner) => Product.fromJson(banner))
                  .toList();
          return ApiResponse<List<Product>>.fromJson(
            responseData,
            (data) => products,
          );
        } else {
          throw Exception(responseData['message'] ?? 'Failed to load products');
        }
      } else {
        throw Exception('Failed: Server returned an error.');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final responseData = e.response!.data;
        return throw Exception(
          responseData['message'] ?? 'Failed to complete the request',
        );
      }
      throw Exception('Failed: DioException: ${e.message}');
    } catch (e) {
      throw Exception('Failed: $e');
    }
  }
}
