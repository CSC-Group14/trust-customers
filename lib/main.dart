import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logitrust_drivers/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:logitrust_drivers/InfoHandler/app_info.dart';
import 'package:logitrust_drivers/mainScreens/rate_driver_screen.dart';
import 'package:logitrust_drivers/mainScreens/search_places_screen.dart';
import 'package:logitrust_drivers/mainScreens/select_active_driver_screen.dart';
import 'package:logitrust_drivers/splashScreen/splash_screen.dart';
import 'package:logitrust_drivers/authentication/login_screen.dart';
import 'package:logitrust_drivers/authentication/register_screen.dart';
import 'package:logitrust_drivers/mainScreens/main_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  // Optionally handle the message data here
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("c23509de-1134-4a59-a802-3d5e133d16cf");
  OneSignal.Notifications.requestPermission(true);

  

  // Firebase Cloud Messaging setup
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize notification service
    NotificationService();

    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MySplashScreen(),
        '/main_screen': (context) => MainScreen(),
        '/login_screen': (context) => Login(),
        '/register_screen': (context) => Register(),
        '/search_places_screen': (context) => SearchPlaces(),
        '/select_active_driver_screen': (context) => SelectActiveDriverScreen(),
        '/rate_driver_screen': (context) => RateDriverScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
