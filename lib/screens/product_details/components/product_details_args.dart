import 'package:demo_app/models/api_model/product_model.dart';
import 'package:demo_app/models/enums/product_size_type.dart';

class ProductDetailsArguments {
  final Product product;
  final SizeType type;

  ProductDetailsArguments({required this.product, required this.type});
}
