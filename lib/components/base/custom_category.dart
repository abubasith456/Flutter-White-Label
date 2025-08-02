import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:demo_app/models/api_model/category_model.dart';
import 'package:demo_app/app_config.dart';
import 'package:demo_app/utils/text_styles.dart';

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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: (categories.length <= itemsPerRow ? 130 : 260),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: itemsPerRow,
                mainAxisSpacing: 20,
                crossAxisSpacing: 16,
                childAspectRatio: screenWidth < 350 ? 0.7 : 0.75,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _CategoryItem(
                  category: categories[index],
                  index: index,
                  onTap: () => onCategorySelected(categories[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _CategoryItem extends StatefulWidget {
  final Category category;
  final int index;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.category,
    required this.index,
    required this.onTap,
  });

  @override
  State<_CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<_CategoryItem>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    // Main container with transparent background
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.1),
                          width: 0.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: _buildImageContent(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Container(
                  constraints: const BoxConstraints(maxWidth: 80),
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    widget.category.name,
                    style: AppTextStyles.categoryName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageContent() {
    return Image.network(
      widget.category.image,
      fit: BoxFit.cover,
      width: 75,
      height: 75,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingWidget(loadingProgress);
      },
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_rounded,
              size: 28,
              color: Colors.grey.withOpacity(0.4),
            ),
            const SizedBox(height: 2),
            Text(
              widget.category.name.isNotEmpty
                  ? widget.category.name.substring(0, 1).toUpperCase()
                  : '?',
              style: AppTextStyles.errorText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(ImageChunkEvent loadingProgress) {
    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            value:
                loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.grey.withOpacity(0.4),
            ),
            backgroundColor: Colors.grey.withOpacity(0.1),
          ),
        ),
      ),
    );
  }
}
