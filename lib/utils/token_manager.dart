import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class TokenManager {
  final String userId;

  TokenManager({required this.userId});

  Future<void> storeToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('Users').child(userId);
        await userRef.update({'deviceToken': token});
        print("Device token stored for user $userId: $token");
      } else {
        print("Failed to get device token.");
      }
    } catch (e) {
      print("Error storing device token: $e");
    }
  }
}
