import 'package:demo_app/latest/models/api_model/banner_model.dart';
import 'package:demo_app/latest/models/api_model/category_model.dart';
import 'package:demo_app/latest/models/api_model/product_model.dart';
import 'package:demo_app/latest/repository/products_repo/products_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Event
abstract class HomeEvent {}

class LoadHomeData extends HomeEvent {}

//State
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String profilePic;
  final List<HomeBanner> banners;
  final List<Category> categories;
  final List<Product> products;

  HomeLoaded({
    required this.profilePic,
    required this.banners,
    required this.categories,
    required this.products,
  });
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductsRepository productsRepository;
  HomeBloc({required this.productsRepository}) : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) async {
      try {
        emit(HomeLoading());
        final bannerResponse = await productsRepository.getBanners();
        final categoriesResponse = await productsRepository.getCategories();
        final products = await productsRepository.getProducts();
        print("BANNER: ${bannerResponse.data?[0].title}");
        print("CAYTEGORY: ${categoriesResponse.data?[0].name}");
        print("PRODUCTS: $products");
        emit(
          HomeLoaded(
            profilePic: "https://randomuser.me/api/portraits/men/1.jpg",
            banners: bannerResponse.data ?? [],
            categories: categoriesResponse.data ?? [],
            products: products.data ?? [],
          ),
        );
      } catch (e) {
        print("Error occured bro!");
        emit(HomeInitial()); // Fallback state if something goes wrong
      }
      ;
    });
  }
}
