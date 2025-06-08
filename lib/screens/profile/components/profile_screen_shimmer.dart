import 'package:flutter/material.dart';
import 'package:demo_app/components/shimmer/base_shimmer.dart';
import 'package:demo_app/app_config.dart';
import 'package:demo_app/utils/responsive_utils.dart';

class ProfileScreenShimmer extends StatelessWidget {
  const ProfileScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    if (ResponsiveUtils.isDesktop(context)) {
      return _buildDesktopShimmer();
    } else if (ResponsiveUtils.isTablet(context)) {
      return _buildTabletShimmer();
    } else {
      return _buildMobileShimmer();
    }
  }

  Widget _buildDesktopShimmer() {
    return SafeArea(
      child: Row(
        children: [
          // Left sidebar shimmer
          Container(
            width: 350,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConfig.backgroundColor,
                  AppConfig.cardColor,
                ],
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildProfileHeaderShimmer(true),
                const SizedBox(height: 40),
              ],
            ),
          ),
          // Right content shimmer
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: _buildOptionsListShimmer(true),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletShimmer() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            children: [
              _buildProfileHeaderShimmer(false),
              const SizedBox(height: 40),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: _buildOptionsListShimmer(false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileShimmer() {
    return SafeArea(
      child: Column(
        children: [
          _buildProfileHeaderShimmer(false),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildOptionsListShimmer(false),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeaderShimmer(bool isDesktop) {
    return ShimmerVariants.forCurrentBrand(
      child: Container(
        padding: EdgeInsets.all(isDesktop ? 30 : 25),
        margin: EdgeInsets.all(isDesktop ? 0 : 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isDesktop ? 0 : 25),
          color: AppConfig.cardColor,
          boxShadow: isDesktop ? [] : [
            BoxShadow(
              color: AppConfig.shadowColor,
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Profile picture shimmer
            Container(
              width: isDesktop ? 120 : 100,
              height: isDesktop ? 120 : 100,
              decoration: BoxDecoration(
                color: AppConfig.greyColor.shade300,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: isDesktop ? 25 : 20),
            // Username shimmer
            Container(
              width: 150,
              height: isDesktop ? 28 : 24,
              decoration: BoxDecoration(
                color: AppConfig.greyColor.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle shimmer
            Container(
              width: 200,
              height: isDesktop ? 16 : 14,
              decoration: BoxDecoration(
                color: AppConfig.greyColor.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsListShimmer(bool isDesktop) {
    return Column(
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ShimmerVariants.subtle(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppConfig.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: AppConfig.shadowColor.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: AppConfig.primaryColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 24 : 20,
                  vertical: isDesktop ? 20 : 16,
                ),
                child: Row(
                  children: [
                    // Icon shimmer
                    Container(
                      width: isDesktop ? 48 : 44,
                      height: isDesktop ? 48 : 44,
                      decoration: BoxDecoration(
                        color: AppConfig.greyColor.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    SizedBox(width: isDesktop ? 20 : 16),
                    // Title shimmer
                    Expanded(
                      child: Container(
                        height: isDesktop ? 16 : 15,
                        decoration: BoxDecoration(
                          color: AppConfig.greyColor.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    // Arrow shimmer
                    Container(
                      width: isDesktop ? 18 : 16,
                      height: isDesktop ? 18 : 16,
                      decoration: BoxDecoration(
                        color: AppConfig.greyColor.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
