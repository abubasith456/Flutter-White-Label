import 'package:demo_app/latest/models/products_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Define the events
abstract class ProductDetailsEvent {}

class LoadProductDetailsEvent extends ProductDetailsEvent {
  final String productId;

  LoadProductDetailsEvent(this.productId);
}

// Define the states
abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final Product product;

  ProductDetailsLoaded(this.product);
}

class ProductDetailsError extends ProductDetailsState {
  final String message;

  ProductDetailsError(this.message);
}

// Define the Bloc that handles the events and emits the appropriate state
class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  // final ProductRepository productRepository;

  ProductDetailsBloc() : super(ProductDetailsInitial()) {
    on<LoadProductDetailsEvent>(_onLoadProductDetails);
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetailsEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(ProductDetailsLoading());

    try {
      // final product = await productRepository.getProductById(event.productId);
      // emit(ProductDetailsLoaded(product));
    } catch (e) {
      emit(ProductDetailsError('Failed to load product details'));
    }
  }
}
