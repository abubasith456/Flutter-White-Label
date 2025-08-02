import 'package:flutter/material.dart';
import 'package:demo_app/models/api_model/product_model.dart';
import 'package:demo_app/models/enums/product_size_type.dart';
import 'package:demo_app/route/route_constants.dart';
import 'package:demo_app/screens/product_details/components/product_details_args.dart';

class NavigationHelper {
  static void navigateToProductDetails(
    BuildContext context,
    Product product, {
    SizeType sizeType = SizeType.number,
  }) {
    Navigator.pushNamed(
      context,
      productDetailsScreenRoute,
      arguments: ProductDetailsArguments(product: product, type: sizeType),
    );
  }

  static void navigateToProducts(
    BuildContext context,
    String categoryName,
    String categoryId,
  ) {
    Navigator.pushNamed(
      context,
      productsScreenRoute,
      arguments: ProductsArguments(
        category: categoryName,
        categoryId: categoryId,
      ),
    );
  }
}

class ProductsArguments {
  final String category;
  final String categoryId;

  ProductsArguments({required this.category, required this.categoryId});
}
