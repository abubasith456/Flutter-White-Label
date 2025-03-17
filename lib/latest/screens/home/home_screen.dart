import 'package:demo_app/latest/components/base_bloc/profile_bloc.dart';
import 'package:demo_app/latest/route/route_constants.dart';
import 'package:demo_app/latest/screens/home/components/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeData()),
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
                    _buildCategories(state.categories),
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
        // BlocBuilder for ProfileBloc
        builder: (context, profileState) {
          return Text(
            profileState is ProfileLoaded
                ? "Hi ${profileState.username}"
                : "Hi Welcome...", // Dynamically set the user name
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
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
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/shopping-bag-icon.svg",
            height: 24,
          ),
          onPressed: () {
            Navigator.pushNamed(context, cartScreenRoute);
          },
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildCarousel(List<String> banners) {
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
                  image: NetworkImage(banner),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildCategories(List<String> categories) {
    return Container(
      height: 200, // Adjusted height for 2 rows
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Creates two rows
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1, // Square-like items
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, productsScreenRoute);
            },
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blueAccent.withOpacity(0.2),
                  child: Icon(Icons.category, color: Colors.blueAccent),
                ),
                const SizedBox(height: 5),
                Text(
                  categories[index],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewProducts(List<Map<String, String>> products) {
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
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          products[index]["image"]!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        products[index]["title"]!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      products[index]["price"]!,
                      style: const TextStyle(color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
