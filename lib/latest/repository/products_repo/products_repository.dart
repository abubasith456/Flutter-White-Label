import 'package:demo_app/latest/models/api_model/banner_model.dart';
import 'package:demo_app/latest/models/api_model/category_model.dart';
import 'package:demo_app/latest/models/api_model/product_model.dart';
import 'package:demo_app/latest/repository/api_model/api_response.dart';

abstract class ProductsRepository {
  Future<ApiResponse<List<HomeBanner>>> getBanners();
  Future<ApiResponse<List<Category>>> getCategories();
  Future<ApiResponse<List<Product>>> getProducts();
  Future<ApiResponse<List<Product>>> getProductsByCategory(String catiegoryId);
}
