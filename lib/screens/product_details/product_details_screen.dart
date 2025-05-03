import 'package:demo_app/models/api_model/product_model.dart';
import 'package:demo_app/screens/cart/components/block/cart_block.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/app_config.dart';
import 'package:demo_app/components/base/custom_button.dart';
import 'package:demo_app/models/enums/product_size_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 300.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background:
                        kIsWeb
                            ? Image.network(
                              widget.product.images[0],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      _errorImageWidget(),
                            )
                            : Image.network(
                              widget.product.images[0],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                  ),
                                );
                              },
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      _errorImageWidget(),
                            ),
                  ),
                  backgroundColor: AppConfig.primaryColor,
                ),
              ];
            },
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
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
                    'Rs.${widget.product.price.toStringAsFixed(2)}',
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
                        '4.5 (120 reviews)',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (widget.product.description.isNotEmpty)
                    Text(
                      widget.product.description,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  const SizedBox(height: 16),

                  if (widget.product.sizes.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Add to Cart',
                    onPressed: _addToCart,
                    icon: const Icon(
                      Icons.shopping_cart,
                      size: 18,
                      color: Colors.white,
                    ),
                    height:
                        MediaQuery.of(context).size.width < 375 ? 50.0 : 60.0,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'Buy Now',
                    onPressed: _buyNow,
                    icon: const Icon(
                      Icons.payment,
                      size: 18,
                      color: Colors.white,
                    ),
                    color: Colors.orange,
                    height:
                        MediaQuery.of(context).size.width < 375 ? 50.0 : 60.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorImageWidget() {
    return Container(
      width: double.infinity,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
    );
  }

  List<Widget> _buildSizeOptions() {
    if (widget.product.sizes.isEmpty) {
      return [];
    }
    return widget.product.sizes.map((size) {
      return _buildSizeOption(size);
    }).toList();
  }

  Widget _buildSizeOption(ProductSize size) {
    bool isOutOfStock = size.stock == 0;

    return GestureDetector(
      onTap:
          isOutOfStock
              ? null
              : () {
                setState(() {
                  selectedSize = size.label;
                });
              },
      child: Chip(
        label: Text(
          '${size.label} (${size.stock > 0 ? "In Stock" : "Out of Stock"})',
        ),
        backgroundColor:
            isOutOfStock
                ? Colors.grey[300] // Disabled look
                : (selectedSize == size.label
                    ? AppConfig.primaryColor
                    : Colors.grey[300]),
        labelStyle: TextStyle(
          color:
              isOutOfStock
                  ? Colors
                      .grey // Greyed-out for out-of-stock sizes
                  : (selectedSize == size.label ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  void _addToCart() {
    // Check if the product has sizes and if a size is selected
    print(
      "widget.product.sizes.isNotEmpty: ${widget.product.sizes.isNotEmpty}",
    );
    print("selectedSize == null: ${selectedSize}");
    if (widget.product.sizes.isNotEmpty && selectedSize == null) {
      // Show a snackbar if no size is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a size before adding to cart'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // If no sizes or size is selected, add to cart
    context.read<CartBloc>().add(
      AddToCart(widget.product, selectedSize: selectedSize),
    );

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _buyNow() {
    // Check if the product has sizes and if a size is selected
    if (widget.product.sizes.isNotEmpty && selectedSize == null) {
      // Show a snackbar if no size is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a size before proceeding'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Just log the action for now
    print('Buying ${widget.product.name} with size: $selectedSize');
  }
}
