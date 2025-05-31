import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A reusable component for displaying network images with error handling and loading indicators.
///
/// This widget attempts to load an image from a network URL and displays:
/// - A loading indicator while the image is loading
/// - A placeholder with an error icon if the image fails to load
class NetworkImageWithError extends StatelessWidget {
  /// The URL of the image to display.
  final String imageUrl;

  /// The width of the image container.
  final double? width;

  /// The height of the image container.
  final double? height;

  /// How the image should be inscribed into the box.
  final BoxFit fit;

  /// Background color for the error container.
  final Color? errorBackgroundColor;

  /// Icon color for the error icon.
  final IconData errorIcon;

  /// Icon color for the error icon.
  final Color errorIconColor;

  /// Size of the error icon.
  final double errorIconSize;

  /// Whether to show a loading indicator while the image is loading.
  final bool showLoadingIndicator;

  /// Color of the loading indicator.
  final Color? loadingIndicatorColor;

  /// Creates a network image with error handling and loading indicator.
  const NetworkImageWithError({
    super.key,
    required this.imageUrl,
    this.width = 80,
    this.height = 80,
    this.fit = BoxFit.cover,
    this.errorBackgroundColor = const Color(0xFFD6D6D6), // Default to grey[300]
    this.errorIcon = Icons.image_not_supported,
    this.errorIconColor = Colors.grey,
    this.errorIconSize = 24,
    this.showLoadingIndicator = true,
    this.loadingIndicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    // For web, we don't use the loading builder as it can cause flickering
    if (kIsWeb) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    }

    // For mobile platforms, we use the loading builder
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      loadingBuilder:
          showLoadingIndicator
              ? (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _buildLoadingWidget(loadingProgress);
              }
              : null,
    );
  }

  /// Builds the widget to display when an error occurs loading the image.
  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: errorBackgroundColor,
      child: Center(
        child: Icon(errorIcon, color: errorIconColor, size: errorIconSize),
      ),
    );
  }

  /// Builds the widget to display while the image is loading.
  Widget _buildLoadingWidget(ImageChunkEvent loadingProgress) {
    return Container(
      width: width,
      height: height,
      color: errorBackgroundColor,
      child: Center(
        child: CircularProgressIndicator(
          value:
              loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
          color: loadingIndicatorColor,
        ),
      ),
    );
  }
}
