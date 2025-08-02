import 'dart:io';

import 'package:demo_app/components/base_bloc/profile_bloc.dart';
import 'package:demo_app/firebase_options.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('⬇️ [BG Handler] Message ${message.messageId}: ${message.data}');
}

Future<String?> initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('✅ Firebase initialized: ${app.name}');

  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  debugPrint('📬 Permission status: ${settings.authorizationStatus}');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (Platform.isIOS) {
    String? apns = await messaging.getAPNSToken();
    if (apns == null) {
      // Retry loop, max 5 sec
      for (int i = 0; i < 5; i++) {
        await Future.delayed(Duration(milliseconds: 500));
        apns = await messaging.getAPNSToken();
        if (apns != null) break;
      }
    }
    debugPrint('📱 APNs token: $apns');
    if (apns == null) {
      throw Exception('APNs token still null after waiting — cannot proceed.');
    }
  }

  final fcmToken = await messaging.getToken();
  debugPrint('🔑 FCM token: $fcmToken');

  FirebaseMessaging.onMessage.listen((msg) {
    debugPrint('🟢 [Foreground] ${msg.notification?.title}');
  });
  FirebaseMessaging.onMessageOpenedApp.listen((msg) {
    debugPrint('➡️ onMessageOpenedApp, data: ${msg.data}');
  });
  final initial = await messaging.getInitialMessage();
  if (initial != null) {
    debugPrint('📲 Launched by notification, data: ${initial.data}');
  }

  return fcmToken;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first
  final token = await initFirebase();

  debugPrint('🔑 FCM device token in main: $token');

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
