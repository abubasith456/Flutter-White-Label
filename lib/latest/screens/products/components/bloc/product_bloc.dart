import 'package:bloc/bloc.dart';
import 'package:demo_app/latest/models/api_model/product_model.dart';
import 'package:demo_app/latest/repository/products_repo/products_repository.dart';
import 'package:equatable/equatable.dart';

// Event

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductsByCategory extends ProductsEvent {
  final String category;
  final String categoryId;

  const LoadProductsByCategory(this.category, this.categoryId);

  @override
  List<Object?> get props => [category];
}

// State

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;

  const ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository productsRepository;
  ProductsBloc({required this.productsRepository}) : super(ProductsInitial()) {
    on<LoadProductsByCategory>((event, emit) async {
      try {
        emit(ProductsLoading());
        final categorisedProduct = await productsRepository
            .getProductsByCategory(event.categoryId);
        print("PRODUCTS: ${categorisedProduct.data?[0].name}");
        emit(ProductsLoaded(categorisedProduct.data ?? []));
      } catch (e) {
        emit(ProductsError('No product available!'));
      }
    });
  }
}
