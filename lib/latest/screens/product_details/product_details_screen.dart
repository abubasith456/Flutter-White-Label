import 'package:demo_app/latest/components/base/custom_appbar.dart';
import 'package:demo_app/latest/models/api_model/product_model.dart';
import 'package:demo_app/latest/screens/cart/components/block/cart_block.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/latest/app_config.dart';
import 'package:demo_app/latest/components/base/custom_button.dart';
import 'package:demo_app/latest/models/enums/product_size_type.dart';
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
  void initState() {
    super.initState();
    // Set default size based on `sizeType`
    switch (widget.sizeType) {
      case SizeType.string:
        selectedSize =
            sizeOptionsString.isNotEmpty ? sizeOptionsString[0] : null;
        break;
      case SizeType.number:
        selectedSize =
            sizeOptionsNumber.isNotEmpty
                ? sizeOptionsNumber[0].toString()
                : null;
        break;
      case SizeType.none:
        selectedSize = null;
        break;
    }
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
                    background: Image.network(
                      widget.product.images[0],
                      fit: BoxFit.cover,
                      width: double.infinity,
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

                  if (widget.sizeType != SizeType.none)
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
                    onPressed: () {
                      context.read<CartBloc>().add(AddToCart(widget.product));
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
        labelStyle: TextStyle(
          color: selectedSize == size ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  void _buyNow() {
    print('Buying ${widget.product.name} with size: $selectedSize');
  }
}
