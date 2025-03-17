import 'package:demo_app/latest/screens/cart/components/block/cart_block.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/latest/app_config.dart';
import 'package:demo_app/latest/components/base/custom_button.dart';
import 'package:demo_app/latest/models/enums/product_size_type.dart';
import 'package:demo_app/latest/models/products_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final SizeType sizeType;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.sizeType,
  });

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? selectedSize;

  final List<String> sizeOptionsNone = [];
  final List<String> sizeOptionsString = ["L", "M", "XL", "XXL"];
  final List<int> sizeOptionsNumber = [20, 30, 40, 50];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: AppConfig.primaryColor,
      ),
      body: Stack(
        children: [
          // Main content area
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align everything to the left
            children: [
              // Product Image Carousel
              Container(
                height: 300.0,
                child: PageView(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    // Placeholder for additional images
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Product Title and Price
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align to left
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\Rs.${widget.product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '4.5 (120 reviews)', // Mock data for now
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Product Description (only if available)
              if (widget.product.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              const SizedBox(height: 16),

              // Size Selection (Only if SizeType is not 'none')
              if (widget.sizeType != SizeType.none)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align to left
                    children: [
                      const Text(
                        'Select Size:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(spacing: 8.0, children: _buildSizeOptions()),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),

          // Add to Cart and Buy Now Buttons at the Bottom
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Add to Cart',
                    onPressed: () => {
                      context.read() <CartBloc>().add(AddToCart(widget.product));
                    },
                    icon: const Icon(Icons.shopping_cart),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Buy Now',
                    onPressed: _buyNow,
                    icon: const Icon(Icons.payment),
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSizeOptions() {
    List<String> sizeOptions = [];

    switch (widget.sizeType) {
      case SizeType.none:
        sizeOptions = sizeOptionsNone;
        break;
      case SizeType.string:
        sizeOptions = sizeOptionsString;
        break;
      case SizeType.number:
        sizeOptions = sizeOptionsNumber.map((size) => size.toString()).toList();
        break;
    }

    return sizeOptions.map((size) {
      return _buildSizeOption(size);
    }).toList();
  }

  Widget _buildSizeOption(String size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: Chip(
        label: Text(size),
        backgroundColor:
            selectedSize == size ? AppConfig.primaryColor : Colors.grey[300],
        labelStyle: const TextStyle(color: Colors.white),
      ),
    );
  }

  void _addToCart(BuildContext context) {
    context.read<CartBloc>().add(AddToCart(widget.product));

    print('Added ${widget.product.name} to cart with size: $selectedSize');
  }

  void _buyNow() {
    print('Buying ${widget.product.name} with size: $selectedSize');
  }
}
