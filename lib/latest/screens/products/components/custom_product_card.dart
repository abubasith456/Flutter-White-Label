import 'package:flutter/material.dart';

class CustomProductCard extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final VoidCallback onTap; // Add onTap callback

  const CustomProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.onTap, // Pass the onTap callback
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Call onTap when the card is tapped
      child: Container(
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
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          size: 50,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text("Rs.$price", style: const TextStyle(color: Colors.green)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
