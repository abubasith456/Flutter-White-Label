import 'package:demo_app/latest/models/enums/product_size_type.dart';
import 'package:demo_app/latest/models/products_model.dart';

class ProductDetailsArguments {
  final Product product;
  final SizeType type;

  ProductDetailsArguments({required this.product, required this.type});
}
