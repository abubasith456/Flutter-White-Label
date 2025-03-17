import 'package:bloc/bloc.dart';
import 'package:demo_app/latest/models/products_model.dart';
import 'package:equatable/equatable.dart';

// Event

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductsByCategory extends ProductsEvent {
  final String category;

  const LoadProductsByCategory(this.category);

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
  final List<Product> _allProducts = [
    Product(
      id: '1',
      name: 'Hijab',
      imageUrl:
          'https://cdn3.iconfinder.com/data/icons/design-n-code/100/272127c4-8d19-4bd3-bd22-2b75ce94ccb4-512.png',
      price: 15.99,
      category: 'Hijab',
      description: "This is sooo nice Hijab",
    ),
    Product(
      id: '2',
      name: 'Scarf',
      imageUrl:
          'https://cdn3.iconfinder.com/data/icons/design-n-code/100/272127c4-8d19-4bd3-bd22-2b75ce94ccb4-512.png',
      price: 10.99,
      category: 'Scarf',
      description: "This is sooo nice Scarf",
    ),
    Product(
      id: '3',
      name: 'T-shirt',
      imageUrl:
          'https://cdn3.iconfinder.com/data/icons/design-n-code/100/272127c4-8d19-4bd3-bd22-2b75ce94ccb4-512.png',
      price: 20.99,
      category: 'Clothing',
      description: "This is sooo nice Clothing",
    ),
    // Add more products here
  ];

  ProductsBloc() : super(ProductsInitial()) {
    on<LoadProductsByCategory>((event, emit) async {
      try {
        emit(ProductsLoading());
        final filteredProducts = _allProducts.toList();
        await Future.delayed(Duration(seconds: 1));
        emit(ProductsLoaded(filteredProducts));
      } catch (e) {
        emit(ProductsError('Failed to load products'));
      }
    });
  }
}
