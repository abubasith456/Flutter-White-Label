// import 'package:demo_app/components/shimmer/base_shimmer.dart';
// import 'package:flutter/material.dart';

// class HomeScreenShimmer extends StatelessWidget {
//   const HomeScreenShimmer({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _buildAppBarShimmer(),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//             _buildCarouselShimmer(),
//             const SizedBox(height: 20),
//             _buildCategoriesShimmer(),
//             const SizedBox(height: 20),
//             _buildProductsShimmer(),
//           ],
//         ),
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBarShimmer() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       leading: const Padding(
//         padding: EdgeInsets.all(10.0),
//         child: BaseShimmerEffect(
//           child: CircleAvatar(backgroundColor: Colors.white),
//         ),
//       ),
//       title: const BaseShimmerEffect(
//         child: SizedBox(
//           width: 120,
//           height: 20,
//           child: DecoratedBox(decoration: BoxDecoration(color: Colors.white)),
//         ),
//       ),
//       actions: const [
//         BaseShimmerEffect(
//           child: Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Icon(Icons.search, color: Colors.white, size: 24),
//           ),
//         ),
//         BaseShimmerEffect(
//           child: Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Icon(
//               Icons.shopping_bag_outlined,
//               color: Colors.white,
//               size: 24,
//             ),
//           ),
//         ),
//         SizedBox(width: 10),
//       ],
//     );
//   }

//   Widget _buildCarouselShimmer() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: BaseShimmerEffect(
//         child: SizedBox(
//           height: 160,
//           child: DecoratedBox(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.all(Radius.circular(15)),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoriesShimmer() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10),
//           child: BaseShimmerEffect(
//             child: SizedBox(
//               width: 100,
//               height: 20,
//               child: DecoratedBox(
//                 decoration: BoxDecoration(color: Colors.white),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 100,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: List.generate(
//               4,
//               (index) => Column(
//                 children: const [
//                   BaseShimmerEffect(
//                     child: SizedBox(
//                       width: 60,
//                       height: 60,
//                       child: DecoratedBox(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   BaseShimmerEffect(
//                     child: SizedBox(
//                       width: 40,
//                       height: 10,
//                       child: DecoratedBox(
//                         decoration: BoxDecoration(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildProductsShimmer() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const BaseShimmerEffect(
//             child: SizedBox(
//               width: 120,
//               height: 20,
//               child: DecoratedBox(
//                 decoration: BoxDecoration(color: Colors.white),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 0.8,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//             ),
//             itemCount: 4,
//             itemBuilder: (context, index) {
//               return const BaseShimmerEffect(
//                 child: DecoratedBox(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:demo_app/components/base_bloc/profile_bloc.dart';
import 'package:demo_app/components/shimmer/base_shimmer.dart';
import 'package:demo_app/route/route_constants.dart';
import 'package:demo_app/screens/cart/components/block/cart_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final String profilePic;

  const HomeScreenAppBar(this.context, this.profilePic, {super.key});

  @override
  Widget build(BuildContext context) {
    final bool isLoading = profilePic.isEmpty;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            if (profileState is ProfileLoaded &&
                profileState.user.profilePic.isNotEmpty) {
              return CircleAvatar(
                backgroundImage: NetworkImage(profileState.user.profilePic),
              );
            }
            return const BaseShimmerEffect(
              child: CircleAvatar(backgroundColor: Colors.white),
            );
          },
        ),
      ),
      title: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (isLoading) {
            return const BaseShimmerEffect(
              child: SizedBox(
                width: 120,
                height: 20,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.white),
                ),
              ),
            );
          }
          return FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              profileState is ProfileLoaded
                  ? "Hi, ${profileState.user.name}"
                  : "Hi, Welcome...",
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
      actions: [
        // Search icon with shimmer
        isLoading
            ? const BaseShimmerEffect(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.search, color: Colors.white, size: 24),
              ),
            )
            : IconButton(
              icon: SvgPicture.asset("assets/icons/search_new.svg", height: 24),
              onPressed: () {
                Navigator.pushNamed(context, searchScreenRoute);
              },
            ),

        // Cart Icon with Badge and shimmer
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (isLoading) {
              return const BaseShimmerEffect(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              );
            }

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
                if (state.cartCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HomeScreenShimmer extends StatelessWidget {
  final Widget? child;

  const HomeScreenShimmer({super.key}) : child = null;
  const HomeScreenShimmer.child({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return BaseShimmerEffect(child: child!);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildCarouselShimmer(),
          const SizedBox(height: 20),
          _buildCategoriesShimmer(),
          const SizedBox(height: 20),
          _buildProductsShimmer(),
        ],
      ),
    );
  }

  Widget _buildCarouselShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BaseShimmerEffect(
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: BaseShimmerEffect(
            child: Container(width: 100, height: 20, color: Colors.white),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (index) => Column(
                children: [
                  BaseShimmerEffect(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  BaseShimmerEffect(
                    child: Container(
                      width: 40,
                      height: 10,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductsShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseShimmerEffect(
            child: Container(width: 120, height: 20, color: Colors.white),
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
            itemCount: 4,
            itemBuilder: (context, index) {
              return BaseShimmerEffect(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
