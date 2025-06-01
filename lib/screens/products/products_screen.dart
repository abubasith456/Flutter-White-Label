import 'package:demo_app/components/base/custom_appbar.dart';
import 'package:demo_app/models/enums/product_size_type.dart';
import 'package:demo_app/route/route_constants.dart';
import 'package:demo_app/screens/product_details/components/product_details_args.dart';
import 'package:demo_app/screens/products/components/bloc/product_bloc.dart';
import 'package:demo_app/screens/products/components/custom_product_card.dart';
import 'package:demo_app/screens/products/components/products_screen_shimmering.dart';
import 'package:demo_app/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsListScreen extends StatelessWidget {
  final String category;
  final String categoryId;

  const ProductsListScreen({
    super.key,
    required this.category,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: category),
      body: BlocProvider(
        create:
            (context) =>
                sl<ProductsBloc>()
                  ..add(LoadProductsByCategory(category, categoryId)),
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const ProductsScreenShimmer();
            }

            if (state is ProductsLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  childAspectRatio: 0.75, // Adjust for card aspect
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return CustomProductCard(
                    image: product.images[0],
                    title: product.name,
                    price: product.price.toString(),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        productDetailsScreenRoute, // Replace with your route name
                        arguments: ProductDetailsArguments(
                          product: product, // Pass the product data
                          type: SizeType.number, // Pass the size type
                        ),
                      );
                    },
                  );
                },
              );
            }

            if (state is ProductsError) {
              return Center(child: Text(state.message));
            }

            return Center(child: Text("No products available."));
          },
        ),
      ),
    );
  }
}
