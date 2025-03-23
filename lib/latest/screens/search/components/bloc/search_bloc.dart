import 'package:demo_app/latest/models/api_model/category_model.dart';
import 'package:demo_app/latest/models/api_model/product_model.dart';
import 'package:demo_app/latest/repository/products_repo/products_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Event
abstract class SearchEvent {}

class LoadData extends SearchEvent {}

class SearchProducts extends SearchEvent {
  final String query;
  final List<String> selectedCategories;

  SearchProducts(this.query, {this.selectedCategories = const []});
}

// State
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchDataLoaded extends SearchState {
  final List<Product> allProducts; // Store all products
  final List<Product> displayedProducts; // Filtered products
  final List<Category> categories;
  final List<String> selectedCategories;

  SearchDataLoaded({
    this.allProducts = const [],
    this.displayedProducts = const [],
    this.categories = const [],
    this.selectedCategories = const [],
  });
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

// Bloc
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductsRepository productRepository;

  SearchBloc({required this.productRepository}) : super(SearchInitial()) {
    on<LoadData>((event, emit) async {
      try {
        final categoriesResponse = await productRepository.getCategories();
        final productsResponse = await productRepository.getProducts();
        emit(
          SearchDataLoaded(
            categories: categoriesResponse.data ?? [],
            allProducts: productsResponse.data ?? [],
            displayedProducts: [], // Initially empty
          ),
        );
      } catch (e) {
        emit(SearchError('Failed to load data: ${e.toString()}'));
      }
    });

    on<SearchProducts>((event, emit) async {
      try {
        if (state is SearchDataLoaded) {
          final currentState = state as SearchDataLoaded;
          final query = event.query.toLowerCase();
          final selectedCategories = event.selectedCategories;

          List<Product> filteredProducts =
              currentState.allProducts.where((product) {
                bool matchesQuery =
                    query.isEmpty || product.name.toLowerCase().contains(query);
                bool matchesCategory =
                    selectedCategories.isEmpty ||
                    selectedCategories.contains(product.category.id);
                return matchesQuery && matchesCategory;
              }).toList();

          if (event.selectedCategories.isEmpty) {
            emit(
              SearchDataLoaded(
                allProducts: currentState.allProducts, // Keep all products
                displayedProducts: [], // Update only displayed list
                categories: currentState.categories,
                selectedCategories: selectedCategories,
              ),
            );
          } else {
            emit(
              SearchDataLoaded(
                allProducts: currentState.allProducts, // Keep all products
                displayedProducts:
                    filteredProducts, // Update only displayed list
                categories: currentState.categories,
                selectedCategories: selectedCategories,
              ),
            );
          }
        }
      } catch (e) {
        emit(SearchError('Failed to search products: ${e.toString()}'));
      }
    });
  }
}
