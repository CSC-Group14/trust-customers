import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logitrust_drivers/global/global.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> selectNotificationSubject =
      BehaviorSubject<String?>();

  NotificationService() {
    _initializeFirebaseMessaging();
    _initializeLocalNotifications();
    _setupSelectNotificationSubject();
  }

  void _initializeFirebaseMessaging() {
    // Request permission for notifications (for iOS)
    _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get the device token
    _firebaseMessaging.getToken().then((token) {
      print("User device token: $token");
      if (token != null) {
        _saveTokenToDatabase(token);
      }
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received: ${message.notification?.title}");
      // Handle foreground messages
      _showNotification(message.notification, message.data['rideRequestId']);
    });

    // App in background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message clicked!");
      // Handle when the user taps on the notification
      _onNotificationTap(message.data['rideRequestId']);
    });
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
      _onNotificationTap(response.payload);
    });
  }

  void _setupSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      _onNotificationTap(payload);
    });
  }

  Future<void> _saveTokenToDatabase(String token) async {
    User? currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      DatabaseReference tokenRef = FirebaseDatabase.instance
          .ref()
          .child('Drivers')
          .child(currentUser.uid)
          .child('deviceToken');
      await tokenRef.set(token);
    }
  }

  void _showNotification(RemoteNotification? notification, String? payload) {
    if (notification != null) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'ride_request_channel', // Channel ID
        'Ride Requests', // Channel Name
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      _flutterLocalNotificationsPlugin.show(
        0,
        notification.title,
        notification.body,
        platformChannelSpecifics,
        payload: payload,
      );
    }
  }

  Future<void> _onNotificationTap(String? payload) async {
    if (payload != null) {
      print("Notification payload: $payload");
      // Navigate to a specific screen based on the payload
      // Example: Navigate to ride request details screen
      _handleNotificationTap(payload);
    }
  }

  void _handleNotificationTap(String payload) {
    // Handle the navigation based on the payload (e.g., ride request ID)
    print("Navigating to screen with payload: $payload");
    // Add your navigation logic here, such as Navigator.push()
  }
}
