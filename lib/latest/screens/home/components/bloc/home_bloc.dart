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
  final List<String> banners;
  final List<String> categories;
  final List<Map<String, String>> products;

  HomeLoaded({
    required this.profilePic,
    required this.banners,
    required this.categories,
    required this.products,
  });
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) {
      emit(HomeLoading());

      // Simulate API call delay
      Future.delayed(Duration(seconds: 10));

      try {
        emit(
          HomeLoaded(
            profilePic: "https://randomuser.me/api/portraits/men/1.jpg",
            banners: [
              "https://t3.ftcdn.net/jpg/04/65/46/52/360_F_465465254_1pN9MGrA831idD6zIBL7q8rnZZpUCQTy.jpg",
              "https://t4.ftcdn.net/jpg/03/48/05/47/360_F_348054737_Tv5fl9LQnZnzDUwskKVKd5Mzj4SjGFxa.jpg",
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEMAIkmXPd0BtlfXfzJQ2Y2QAqW97UfnTzzA&s",
            ],
            categories: [
              "Shoes",
              "Clothing",
              "Accessories",
              "Watches",
              "Bags",
              "Shoes",
              "Clothing",
              "Accessories",
              "Watches",
              "Bags",
            ],
            products: List.generate(
              6,
              (index) => {
                "title": "Product $index",
                "image":
                    "https://media.istockphoto.com/id/1147544807/vector/thumbnail-image-vector-graphic.jpg?s=612x612&w=0&k=20&c=rnCKVbdxqkjlcs3xH87-9gocETqpspHFXu5dIGB4wuM=",
                "price": "\$${(index + 1) * 10}",
              },
            ),
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
