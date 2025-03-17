import 'package:demo_app/latest/models/search_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Event
abstract class SearchEvent {}

class LoadCategories extends SearchEvent {}

class SearchProducts extends SearchEvent {
  final String query;
  SearchProducts(this.query);
}

// State
abstract class SearchState {}

class SearchInitial extends SearchState {}

class CategoriesLoaded extends SearchState {
  final List<Category> categories;
  CategoriesLoaded(this.categories);
}

class ProductsLoaded extends SearchState {
  final List<Product> products;
  ProductsLoaded(this.products);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final List<Product> _allProducts = [
    Product(
      id: '1',
      name: 'Hijab',
      imageUrl:
          'https://cdn1.iconfinder.com/data/icons/image-manipulations/100/13-512.png',
      price: 15.99,
      category: 'Hijab',
    ),
    Product(
      id: '2',
      name: 'Scarf',
      imageUrl:
          'https://cdn1.iconfinder.com/data/icons/image-manipulations/100/13-512.png',
      price: 10.99,
      category: 'Scarf',
    ),
    Product(
      id: '3',
      name: 'T-shirt',
      imageUrl:
          'https://cdn1.iconfinder.com/data/icons/image-manipulations/100/13-512.png',
      price: 20.99,
      category: 'Clothing',
    ),
    // Add more products here
  ];

  final List<Category> _categories = [
    Category(
      name: 'Hijab',
      imageUrl:
          'https://cdn1.iconfinder.com/data/icons/image-manipulations/100/13-512.png',
    ),
    Category(
      name: 'Scarf',
      imageUrl:
          'https://cdn1.iconfinder.com/data/icons/image-manipulations/100/13-512.png',
    ),
    Category(
      name: 'Clothing',
      imageUrl:
          'https://cdn1.iconfinder.com/data/icons/image-manipulations/100/13-512.png',
    ),
    // Add more categories here
  ];

  SearchBloc() : super(SearchInitial()) {
    on<LoadCategories>((event, emit) async {
      try {
        emit(CategoriesLoaded(_categories)); // Load categories
      } catch (e) {
        emit(SearchError('Failed to load categories'));
      }
    });

    on<SearchProducts>((event, emit) async {
      try {
        final query =
            event.query.toLowerCase(); // Default to empty string if null
        if (query.isEmpty) {
          emit(ProductsLoaded([])); // Return empty list if query is empty
          return;
        }

        final filteredProducts =
            _allProducts
                .where((product) => product.name.toLowerCase().contains(query))
                .toList();

        emit(
          ProductsLoaded(filteredProducts),
        ); // Filter products based on search query
      } catch (e) {
        emit(SearchError('Failed to search products: ${e.toString()}'));
      }
    });
  }
}
