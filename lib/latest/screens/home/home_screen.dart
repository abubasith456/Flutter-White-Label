import 'package:demo_app/latest/app_config.dart';
import 'package:demo_app/latest/components/base/custom_category.dart';
import 'package:demo_app/latest/components/base_bloc/profile_bloc.dart';
import 'package:demo_app/latest/models/api_model/category_model.dart';
import 'package:demo_app/latest/models/api_model/product_model.dart';
import 'package:demo_app/latest/models/enums/product_size_type.dart';
import 'package:demo_app/latest/route/route_constants.dart';
import 'package:demo_app/latest/screens/cart/components/block/cart_block.dart';
import 'package:demo_app/latest/screens/home/components/bloc/home_bloc.dart';
import 'package:demo_app/latest/screens/product_details/components/product_details_args.dart';
import 'package:demo_app/latest/screens/products/components/custom_product_card.dart';
import 'package:demo_app/latest/screens/products/components/product_args.dart';
import 'package:demo_app/latest/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo_app/latest/models/api_model/banner_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeBloc>()..add(LoadHomeData()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HomeLoaded) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: _buildAppBar(context, state.profilePic),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildCarousel(state.banners),
                    const SizedBox(height: 20),
                    _buildCategories(state.categories, context),
                    const SizedBox(height: 20),
                    _buildNewProducts(state.products),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String profilePic) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CircleAvatar(backgroundImage: NetworkImage(profilePic)),
      ),
      title: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          return FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              profileState is ProfileLoaded
                  ? "Hi, ${profileState.user.name}"
                  : "Hi, Welcome...",
              style: TextStyle(
                fontSize: 17, // Base size
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset("assets/icons/search_new.svg", height: 24),
          onPressed: () {
            Navigator.pushNamed(context, searchScreenRoute);
          },
        ),

        // Cart Icon with Badge
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return Stack(
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/shopping-bag-icon.svg",
                    height: 24,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, cartScreenRoute);
                  },
                ),
                if (state.cartCount > 0) // Show badge only when cart count > 0
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '${state.cartCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildCarousel(List<HomeBanner> banners) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 160,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.85,
      ),
      items:
          banners.map((banner) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(banner.image),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildCategories(List<Category> categories, BuildContext context) {
    final int count = categories.length > 4 ? 2 : 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Categories",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConfig.primaryTextColor,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: CustomCategoryList(
            categories: categories,
            onCategorySelected: (category) {
              Navigator.pushNamed(
                context,
                productsScreenRoute,
                arguments: ProductsArguments(
                  category: category.name,
                  categoryId: category.id,
                ),
              );
            },
          ),
        ),
        // Container(
        //   height: count == 1 ? 100 : 200, // Adjusted height for 2 rows
        //   margin: const EdgeInsets.symmetric(vertical: 10),
        //   child: GridView.builder(
        //     scrollDirection: Axis.horizontal,
        //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: count, // Creates two rows
        //       mainAxisSpacing: 10,
        //       crossAxisSpacing: 10,
        //       childAspectRatio: 1.0, // Square-like items
        //     ),
        //     itemCount: categories.length,
        //     itemBuilder: (context, index) {
        //       return GestureDetector(
        //         onTap: () {
        //           Navigator.pushNamed(
        //             context,
        //             productsScreenRoute,
        //             arguments: ProductsArguments(
        //               category: categories[index].name,
        //               categoryId: categories[index].id,
        //             ),
        //           );
        //         },
        //         child: Column(
        //           children: [
        //             // Replace Icon with Image
        //             CircleAvatar(
        //               radius: 30,
        //               backgroundColor: Colors.blueAccent.withOpacity(0.2),
        //               child: ClipOval(
        //                 child: Image.network(
        //                   categories[index]
        //                       .image, // Replace with the correct field name for the image URL
        //                   fit:
        //                       BoxFit
        //                           .cover, // Ensures the image fits the CircleAvatar shape
        //                   width: 60, // Adjust as needed
        //                   height: 60, // Adjust as needed
        //                   loadingBuilder: (
        //                     BuildContext context,
        //                     Widget child,
        //                     ImageChunkEvent? loadingProgress,
        //                   ) {
        //                     if (loadingProgress == null) {
        //                       return child;
        //                     } else {
        //                       return Center(
        //                         child: CircularProgressIndicator(
        //                           value:
        //                               loadingProgress.expectedTotalBytes != null
        //                                   ? loadingProgress
        //                                           .cumulativeBytesLoaded /
        //                                       (loadingProgress
        //                                               .expectedTotalBytes ??
        //                                           1)
        //                                   : null,
        //                         ),
        //                       );
        //                     }
        //                   },
        //                   errorBuilder: (context, error, stackTrace) {
        //                     return Icon(
        //                       Icons.error,
        //                     ); // Show an error icon if the image fails to load
        //                   },
        //                 ),
        //               ),
        //             ),
        //             const SizedBox(height: 5),
        //             Text(
        //               categories[index].name,
        //               style: const TextStyle(
        //                 fontSize: 14,
        //                 fontWeight: FontWeight.w500,
        //               ),
        //             ),
        //           ],
        //         ),
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }

  Widget _buildNewProducts(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "New Arrivals",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5),
                child: CustomProductCard(
                  image: products[index].images[0],
                  title: products[index].name,
                  price: products[index].price.toString(),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      productDetailsScreenRoute, // Replace with your route name
                      arguments: ProductDetailsArguments(
                        product: products[index], // Pass the product data
                        type: SizeType.number, // Pass the size type
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
