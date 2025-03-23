import 'package:flutter/material.dart';
import 'package:demo_app/latest/models/api_model/category_model.dart';

class CustomCategoryList extends StatelessWidget {
  final List<Category> categories;
  final Function(Category) onCategorySelected;

  const CustomCategoryList({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const int itemsPerRow = 4;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (categories.length > 8) {
          // If more than 8 categories, use a horizontal scrollable list
          return SizedBox(
            height: (categories.length <= itemsPerRow ? 100 : 200),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: itemsPerRow,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: screenWidth < 350 ? 1 : 1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryItem(categories[index]);
              },
            ),
          );
        } else {
          // Otherwise, use a GridView for up to 8 items
          return SizedBox(
            height:
                (categories.length <= itemsPerRow
                    ? 100
                    : 200), // Adjusts height dynamically
            child: GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(), // Prevents grid scrolling
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: itemsPerRow, // 4 items per row
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio:
                    screenWidth < 350 ? 1 : 1, // Adjusts for small screens
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryItem(categories[index]);
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildCategoryItem(Category category) {
    return GestureDetector(
      onTap: () => onCategorySelected(category),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                category.image,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            category.name,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
