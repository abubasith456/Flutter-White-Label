import 'package:demo_app/app_config.dart';
import 'package:demo_app/components/base/custom_category.dart';
import 'package:demo_app/components/base_bloc/profile_bloc.dart';
import 'package:demo_app/models/api_model/category_model.dart';
import 'package:demo_app/models/api_model/product_model.dart';
import 'package:demo_app/models/enums/product_size_type.dart';
import 'package:demo_app/route/route_constants.dart';
import 'package:demo_app/screens/cart/components/block/cart_block.dart';
import 'package:demo_app/screens/home/components/bloc/home_bloc.dart';
import 'package:demo_app/screens/home/components/home_screen_shiimmer.dart';
import 'package:demo_app/screens/product_details/components/product_details_args.dart';
import 'package:demo_app/screens/products/components/custom_product_card.dart';
import 'package:demo_app/screens/products/components/product_args.dart';
import 'package:demo_app/services/service_locator.dart';
import 'package:demo_app/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demo_app/models/api_model/banner_model.dart';
import 'package:demo_app/utils/navigation_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeBloc>()..add(LoadHomeData()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: HomeScreenAppBar(context, ""),
              body: const HomeScreenShimmer(),
            );
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
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            if (profileState is ProfileLoaded &&
                profileState.user.profilePic.isNotEmpty) {
              profilePic = profileState.user.profilePic;
            }

            return CircleAvatar(backgroundImage: NetworkImage(profilePic));
          },
        ),
      ),
      title: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          return FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              profileState is ProfileLoaded
                  ? "Hi, ${profileState.user.name}"
                  : "Hi, Welcome...",
              style: AppTextStyles.appBarTitle,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 180,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          enlargeCenterPage: true,
          viewportFraction: 0.9,
          enlargeStrategy: CenterPageEnlargeStrategy.zoom,
        ),
        items:
            banners.map((banner) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 0,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Image.network(
                        banner.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildCategories(List<Category> categories, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Categories", style: AppTextStyles.sectionHeader),
                TextButton(
                  onPressed: () {
                    // Navigate to all categories
                  },
                  child: Text(
                    "View All",
                    style: TextStyle(
                      color: AppConfig.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          CustomCategoryList(
            categories: categories,
            onCategorySelected: (category) {
              NavigationHelper.navigateToProducts(
                context,
                category.name,
                category.id,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNewProducts(List<Product> products) {
    return Container(
      margin: const EdgeInsets.only(bottom: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("New Arrivals", style: AppTextStyles.sectionHeader),
                TextButton(
                  onPressed: () {
                    // Navigate to all products
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(
                      color: AppConfig.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: products.length > 6 ? 6 : products.length,
              itemBuilder: (context, index) {
                return CustomProductCard(
                  image: products[index].images[0],
                  title: products[index].name,
                  price: products[index].price.toString(),
                  onTap: () {
                    NavigationHelper.navigateToProductDetails(
                      context,
                      products[index],
                      sizeType: SizeType.number,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
