import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:todo_list_poc_task/core/utils/local_notification_service.dart';
import 'package:todo_list_poc_task/core/utils/preference_keys.dart';

import '../main.dart';

Future<void> onHandleBackGroundMessage(RemoteMessage message) async {
  print(message.notification?.title);
  print(message.notification?.body);
  if (DateTime.tryParse(message.data['date'] ?? "") != null) {
    LocalNotification.scheduleNotification(
      flutterLocalNotificationsPlugin,
      DateTime.parse(message.data["date"]),
      message.notification?.title ?? "",
      message.notification?.body ?? "",
    );
  }
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final _fcmToken = await _firebaseMessaging.getToken();
    prefs?.setString(PreferenceKeys.fcmToken, _fcmToken ?? "");
    print("_fcmToken $_fcmToken");
    FirebaseMessaging.onBackgroundMessage(onHandleBackGroundMessage);
    FirebaseMessaging.onMessage.listen((event) {
      print("event: ${event.notification?.title}");
      print("event: ${event.notification?.body}");
      print("event: ${event.data}");
      if (DateTime.tryParse(event.data['date'] ?? "") != null) {
        LocalNotification.scheduleNotification(
          flutterLocalNotificationsPlugin,
          DateTime.parse(event.data["date"]),
          event.notification?.title ?? "",
          event.notification?.body ?? "",
        );
      }
    });
  }

  Future<void> getAccessToken() async {
    // ADD JSON DATA
    final serviceAccountJson = {
      // ADD JSON DATA HERE
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    AutoRefreshingAuthClient? client;

    try {
      client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);
      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client,
      );
      await prefs?.setString(
          PreferenceKeys.accessToken, credentials.accessToken.data);
      // return credentials.accessToken.data;
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: "Please check your internet connection.");
    } finally {
      client?.close();
    }
  }
}
