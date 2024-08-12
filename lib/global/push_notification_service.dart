import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class PushNotificationsService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "logi-trust-app",
      "private_key_id": "90e9b6631f10511812b831ac0b78290d6783e550",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC9ADfiQVWF3DYn\nDKypUVTBxlUFHbC68cf+Nh64JmJXflnXbqo0zV40uY+IkcSDmOkgj8shMxZz3x8L\ntk0Up/m+Mb4asCbuH8px3BQjkfpvjeIWVXybPW33QxZnHrW2kc0cCd6m3lDyB0JW\ndGGGbYeRjEjzNlR/T1wLRFLa1dkTmlxAfRxL4ia21DY0uf2Pjo63S6iXP/ykAewd\nFHFGt0E5AmI8SwX3Aa+UDkjG2hLj3BRTS5EE0H6JH5W6fBpSBZzZUXH4j5+PFrXj\nnDorqo4TG22uOocy4cu1jK7G/rOmFxHY9d6THnUf1udfIq3wnJ56Yw79fDRnCNBo\nGdFQZag9AgMBAAECggEABIjvTlX7+9jDUd+LewqRCo88NgG23l1zy4U36no9TNUi\nybkFi3vMAV7cc03wFapDGb1phdPoe4JEh+7pXZAEPYyK/6/vVzJbFK1PrGTRygBx\nBtEpSr5IF7E75eCGQqmv7rbL6VwXPB9xd4qWVnflU1g23eMVVvKsBjcu98I+0aoN\nbkiTYmw7FtA7rcBAIaKs00sN+l3tcd0VER0ZfK4ZzdEOJkKN5jKQw8ahlXmCKoWu\ny3Uol3lSy48P68YCr1qz2wJ5DVlOxBq9apLGnhjYOOLyJTbUJdc57ejc0BeOqPqF\nXusgL6Qp8qbo69aXfHxLLUCbyHhnV4kuCT+EthiugQKBgQDpzsfaaspIcK050sdC\nrI1CL5pSq/GNEc5eYAKmwlUg0QUsKjTtN2dg4hAw6IpceSOEEcJF+IdjzGt/s7Zf\neGclKHfSIY2uzQU2MhQrE7VZZuEKmMB8LmEhmN2rZ+MpFO9j3cG84ucLiLWfj0Fw\nnVIm4tfAeCBX3HQlIjKj76g6wQKBgQDO8LCCRCMZcaX4O91sMULU4Oz0/FWMVsaS\nWK1o38e3Fttvply5oiRdx6lhMRREsoodTDUJgAx/73Az2GLWON/L/FW/c6Rk7cdX\nRMBGTYZJzIQhH+ZoWs5bS69Nc7kB5GWRQdvL7oLa2K3tF9WgyEwRl2qUGrIX+PRN\nGyjfddb4fQKBgQCT02WQt0xGGNetY5MQmMCHREmyU3xZ0RRFnzaN8PiZ0w4OKnFk\nOk9mdgf+pEg2x3CpJAFM9CHF+41MJHf+TMYKPFflx8ko5/+PkIIn6kIS0HUgmgu5\neCl5cIlWwkxhwRbKcX74yg2CwWD0DUM2zIEQjQQUcN8iLgRRJhoWhIQ9AQKBgBL6\n+oWIMFv2E434F7ADuKiD1NgHiOUtVFs57PXQiKXfX9MWxCx2lbVQSdXTRZOjeI2F\nXtv3Na5KTNVEhJQ3dTdldovv1GU5de4oLSaFl8qPCpNrNJvfsEupXnPRKGfnBfXT\nv5At2SyvcQxtAjgUBv4aEDlzVWBjgizMT+xnB4eVAoGAYqrk89bTqfHXW72vjWxG\ncbPvRI2hPkf6Q4ba+467H5cuEpVL76Jd31aiOjc9gb2Sa1WCqQHnwNpoOiF+Dbcl\nc3I8GAeWBJRzkq0O51/NtCyieODHDRCT4vqq4ECbjWx/Pt8HEYFWYoiIJCIK12k3\nPUKCXkIZcVSc8ZxKTeTvJhA=\n-----END PRIVATE KEY-----\n",
      "client_email": "logi-trust-app@logi-trust-app.iam.gserviceaccount.com",
      "client_id": "106834480703698202919",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/logi-trust-app%40logi-trust-app.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };
    List<String> scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging'
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    try {
      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
              auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
              scopes,
              client);
      return credentials.accessToken.data;
    } catch (e) {
      print("Failed to get access token: $e");
      rethrow;
    } finally {
      client.close();
    }
  }

  static Future<List<String>> fetchOnlineDrivers() async {
    DatabaseReference driversRef =
        FirebaseDatabase.instance.ref().child("Drivers");
    DataSnapshot snapshot =
        await driversRef.orderByChild("newRideStatus").equalTo("Idle").get();

    List<String> deviceTokens = [];
    if (snapshot.exists) {
      Map<dynamic, dynamic> drivers = snapshot.value as Map<dynamic, dynamic>;
      drivers.forEach((key, value) {
        if (value["token"] != null) {
          deviceTokens.add(value["token"]);
        }
      });
    }
    return deviceTokens;
  }

  static sendNotificationToDriver(
      String deviceRegistrationToken, context, String? rideRequestID) async {
    try {
      final String serverAccessTokenKey = await getAccessToken();
      print('Access Token: $serverAccessTokenKey'); // Debugging line
      String endpointFirebaseCloudMessaging =
          'https://fcm.googleapis.com/v1/projects/logi-trust-app/messages:send';
      final Map<String, dynamic> message = {
        'message': {
          'token': deviceRegistrationToken,
          'notification': {
            'title': 'NEW TRIP REQUEST',
            'body': "You have a new ride request!",
          },
          'data': {"rideRequestId": rideRequestID}
        }
      };
      final http.Response response = await http.post(
        Uri.parse(endpointFirebaseCloudMessaging),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverAccessTokenKey'
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully.');
      } else {
        print('Failed, Notification not sent. Reason : ${response.statusCode}');
        print('Response body: ${response.body}'); // Debugging line
      }
    } catch (e) {
      print('Error sending notification: $e'); // Debugging line
    }
  }
}
