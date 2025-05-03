import 'package:demo_app/components/base_bloc/profile_bloc.dart';
import 'package:demo_app/repository/auth_repo/auth_repository.dart';
import 'package:demo_app/screens/address/components/bloc/adress_bloc.dart';
import 'package:demo_app/screens/cart/components/block/cart_block.dart';
import 'package:demo_app/screens/search/components/bloc/search_bloc.dart';
import 'package:demo_app/services/service_locator.dart';
import 'package:demo_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:demo_app/route/route_constants.dart';
import 'package:demo_app/route/router.dart' as router;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set default status bar settings for the entire app
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await setupServiceLocator();

  runApp(
    MultiRepositoryProvider(
      providers: [RepositoryProvider.value(value: sl<SharedPreferences>())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ProfileBloc(sl<AuthRepository>())),
          BlocProvider(create: (context) => sl<AddressBloc>()),
          BlocProvider(create: (context) => sl<CartBloc>()..add(LoadCart())),
          BlocProvider(create: (context) => sl<SearchBloc>()),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop your favourite items',
      theme: AppTheme.lightTheme(context),
      themeMode: ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      initialRoute: splashScreenRouter,
      // home: AddressScreen(), //For test purpose
    );
  }
}
