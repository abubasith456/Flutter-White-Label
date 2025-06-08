import 'package:demo_app/app_config.dart';
import 'package:demo_app/components/base/custom_button.dart';
import 'package:flutter/material.dart';

class EmptyCartWidget extends StatelessWidget {
  final VoidCallback onContinueShopping;

  const EmptyCartWidget({super.key, required this.onContinueShopping});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty cart illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color: Colors.grey[400],
              ),
            ),

            const SizedBox(height: 32),

            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Looks like you haven\'t added any items to your cart yet. Start shopping to fill it up!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Start Shopping',
                onPressed: onContinueShopping,
                isGradient: true,
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Additional helpful links
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextButton.icon(
                      onPressed: () {
                        // Navigate to categories or featured products
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        backgroundColor: AppConfig.primaryColor.withOpacity(
                          0.1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        Icons.category_outlined,
                        size: 18,
                        color: AppConfig.primaryColor,
                      ),
                      label: Text(
                        'Categories',
                        style: TextStyle(
                          color: AppConfig.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextButton.icon(
                      onPressed: () {
                        // Navigate to wishlist or favorites
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        backgroundColor: AppConfig.primaryColor.withOpacity(
                          0.1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        Icons.favorite_outline,
                        size: 18,
                        color: AppConfig.primaryColor,
                      ),
                      label: Text(
                        'Wishlist',
                        style: TextStyle(
                          color: AppConfig.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
