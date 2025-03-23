import 'package:demo_app/latest/components/base/custom_dialog.dart';
import 'package:demo_app/latest/components/base_bloc/profile_bloc.dart';
import 'package:demo_app/latest/repository/address_repository.dart';
import 'package:demo_app/latest/repository/auth_repo/auth_repository.dart';
import 'package:demo_app/latest/repository/auth_repo/auth_repository_impl.dart';
import 'package:demo_app/latest/repository/cart_repo.dart';
import 'package:demo_app/latest/repository/products_repo/products_repository.dart';
import 'package:demo_app/latest/repository/products_repo/products_repository_impl.dart';
import 'package:demo_app/latest/screens/address/components/bloc/adress_bloc.dart';
import 'package:demo_app/latest/screens/cart/components/block/cart_block.dart';
import 'package:demo_app/latest/screens/forgot/components/bloc/forgot_bloc.dart';
import 'package:demo_app/latest/screens/home/components/bloc/home_bloc.dart';
import 'package:demo_app/latest/screens/login/components/bloc/login_bloc.dart';
import 'package:demo_app/latest/screens/products/components/bloc/product_bloc.dart';
import 'package:demo_app/latest/screens/search/components/bloc/search_bloc.dart';
import 'package:demo_app/latest/screens/signup/components/bloc/signup_bloc.dart';
import 'package:demo_app/latest/screens/splash/components/bloc/splash_bloc.dart';
import 'package:demo_app/latest/services/shared_pref_service.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Initialize SharedPreferences first
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Now register SharedPrefService AFTER SharedPreferences is ready
  sl.registerLazySingleton<SharedPrefService>(
    () => SharedPrefService(sharedPreferences),
  );

  // Utils
  sl.registerLazySingleton<DialogService>(() => DialogService());

  // Register dependencies
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(dio: sl()));
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(dio: sl()),
  );

  //Block containers

  sl.registerFactory<AddressBloc>(() => AddressBloc(sl<AddressRepository>()));

  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepository(sharedPreferences),
  );

  sl.registerLazySingleton<CartRepository>(
    () => CartRepository(sharedPreferences),
  );
  // Register LoginBloc using AuthRepository interface
  sl.registerFactory<SplashBloc>(
    () => SplashBloc(sharedPrefService: sl<SharedPrefService>()),
  );
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(authRepository: sl<AuthRepository>()),
  );
  sl.registerFactory<SignupBloc>(
    () => SignupBloc(authRepository: sl<AuthRepository>()),
  );
  sl.registerFactory<ForgotPasswordBloc>(
    () => ForgotPasswordBloc(authRepository: sl<AuthRepository>()),
  );
  sl.registerFactory<HomeBloc>(
    () => HomeBloc(productsRepository: sl<ProductsRepository>()),
  );
  sl.registerFactory<ProductsBloc>(
    () => ProductsBloc(productsRepository: sl<ProductsRepository>()),
  );
  sl.registerFactory<CartBloc>(() => CartBloc(sl<CartRepository>()));
  sl.registerFactory<SearchBloc>(
    () => SearchBloc(productRepository: sl<ProductsRepository>()),
  );
}
