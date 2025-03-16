import 'package:demo_app/latest/components/base_bloc/profile_bloc.dart';
import 'package:demo_app/latest/repository/address_repository.dart';
import 'package:demo_app/latest/repository/cart_repo.dart';
import 'package:demo_app/latest/screens/address/address_screen.dart';
import 'package:demo_app/latest/screens/address/components/bloc/adress_bloc.dart';
import 'package:demo_app/latest/screens/cart/components/block/cart_block.dart';
import 'package:demo_app/latest/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/latest/route/route_constants.dart';
import 'package:demo_app/latest/route/router.dart' as router;
import 'package:demo_app/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileBloc()),
        BlocProvider(create: (context) => sl<AddressBloc>()),
        BlocProvider(create: (context) => CartBloc()..add(LoadCart())),
      ],
      child: MyApp(),
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
      initialRoute: onbordingScreenRoute,
      // home: AddressScreen(), //For test purpose
    );
  }
}
