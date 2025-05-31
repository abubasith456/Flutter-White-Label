// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

//   Future<void> initialize() async {
//     // Request permission
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // Initialize local notifications
//     const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initializationSettingsIOS = DarwinInitializationSettings();
//     const initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await _localNotifications.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: _onSelectNotification,
//     );

//     // Handle background messages
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // Handle foreground messages
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

//     // Handle notification open events when app is in background
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpen);

//     // Get FCM token
//     final token = await _firebaseMessaging.getToken();
//     print('FCM Token: $token');
//   }

//   Future<void> _handleForegroundMessage(RemoteMessage message) async {
//     print('Foreground Message: ${message.notification?.title}');
    
//     await _showLocalNotification(
//       title: message.notification?.title ?? '',
//       body: message.notification?.body ?? '',
//       payload: message.data.toString(),
//     );
//   }

//   Future<void> _handleNotificationOpen(RemoteMessage message) async {
//     print('Notification opened: ${message.notification?.title}');
//     // Handle notification tap
//   }

//   void _onSelectNotification(NotificationResponse response) {
//     print('Notification clicked: ${response.payload}');
//     // Handle notification tap
//   }

//   Future<void> _showLocalNotification({
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'default_channel',
//       'Default Channel',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const iosDetails = DarwinNotificationDetails();

//     const details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _localNotifications.show(
//       DateTime.now().millisecond,
//       title,
//       body,
//       details,
//       payload: payload,
//     );
//   }
// }

// // Handle background messages
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Background Message: ${message.notification?.title}');
// }