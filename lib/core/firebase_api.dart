import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:todo_list_poc_task/core/utils/local_notification_service.dart';

import '../main.dart';

Future<void> onHandleBackGroundMessage(RemoteMessage message) async {
  print(message.notification?.title);
  print(message.notification?.body);
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final _fcmToken = await _firebaseMessaging.getToken();
    prefs?.setString("fcmToken", _fcmToken ?? "");
    print(_fcmToken);
    FirebaseMessaging.onBackgroundMessage(onHandleBackGroundMessage);
    FirebaseMessaging.onMessage.listen((event) {
      print("event: ${event.notification?.title}");
      print("event: ${event.notification?.body}");
      print("event: ${event.data}");
      if (DateTime.tryParse(event.data['date']) != null) {
        LocalNotification.scheduleNotification(
          flutterLocalNotificationsPlugin,
          DateTime.parse(event.data["date"]),
          event.notification?.title ?? "",
          event.notification?.body ?? "",
        );
      }
    });
  }

  Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "poc-todo-app-74fe1",
      "private_key_id": "a51fdd121d4b4d27319f53967564fd3cb72128e0",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQD2vqnoCQKwlT9A\nP8IH3tQP6najkz+xNwkf+yl/m4rgb+kl6qrZAB1kCrYlscxQ/pcGE0oKt1eGKVcK\n3p4mrsNomKlK8W1/N+IkVBh+iwiHlxEGI7ZUaGnGYx1Tr7yMzkWINfTZz1CsR+Z1\nAMx3FuJwDy55AC/ByzQ4SJQL9OJLujN8/cNor/o4n8kxpN5XsZWtwuNK2DcZu+GU\nD/nIrOVdaGVJ8x3oiKiCMx2MWYoKXRIKNvPskLovaRDf6C8crNt+wgQdj3nPztPP\n5sNJ6TbrWJ2rtTSFZaWZAgjTKOQzlPkgIgqA/avzMvq7Q9oRXxqPaFK99HGvyR8Y\n85Uuji3jAgMBAAECggEARcsJkT4XOi6FHR3LuuEvF69ozn0Em5JnLNok01kCT9in\n2JdHqyjKp3UWL5RaqCBTRJ8pJt3UTnkcC1GL54IweMIRxMaEg+MhPshgw059Y6j5\n4kQwuzBrlveLIJRJX4SrC0vDzeZDue9+guLuctMQysSojwZb+9OIGlGBOt6SMfvT\njMylMwz4sblhqfLcDnaypAk/1vTEO2Faf4g0SBWpvYftpqkLI+Rl1z5Iv49vVQhj\n7qW0gfKz9kTprWmQ++arcrBqnfh8nCPAGv4X/lUeudpl/cf4g430mfT1BU2qsCpa\nz5MMVIoiLeMjSAXTEfk1exTya12QkfkT/i2wG0wx9QKBgQD78A+8RpRKrI7f8lPb\nYhMCqlt2xG6XgAxLYKhoOHDLqiA6lerRXdZks/inVHajaYXZFaOlz1hx1tt0LC4a\nuRpDZE1LIYJY6IBMd3zhu8+0oIclOPxIut0IWY3YcVGlCY22MmLroabGlSEnRAsx\nE1Q34WJR3R9T6jOxAilJOkncdQKBgQD6uSq8Z8wTU9TRsm2XSVoW/aIMZhbUsLSp\n3FZtH0VgSWK8BCB4DrfK4LKCyZPh5+Afl9ObyRZd6tJmUkDtY/GBIC6Xi6wXsM0c\n/g2Thgh7CRo1h7FwX0ls1rLPXw/8DruMnndYYd7fIAgL3ObZbSAD4axbV5x2WP6u\np0XyNEV19wKBgD77xPNMscX5Xb6e1lgCLL592F/Yu80kNe6iO3fSpGBGJ8h9sjal\nPvPuCjvK4d34g33B6yeIrpPHIxXn9Z64p9gxOyGNPwj7FxgGxzGnwkVl3GNx26BT\nFu7/dHan3cFkogjqj9BYmVkL7z3hxOp/6o4NyoaswSg5ZLLb13Z3HAABAoGAIPNW\n533otx2MWabOelR8j4rz0hdUps02YSCBB0RV1MqwPC96qOyeQP5413Fwiv7zWJOW\njuHFm8AxuJrUx54b7jFxjh8gFdj5i/bjh+DUmn7ev+w+aJtNRg2NYG2I50J0aY2l\n96qdJMvL4us8N5T84SW2hiakfHVDu2ZmbedqvY8CgYBbry6RO7oMtSUZ1qwg4o5r\n1PjMbwqstwUaMXstZf64iDrpFQCWl3feWCqN80ggo/JLHv4wQZr+SR+l8nvq3e9h\n1r3F5Hgh8ISs01ukMBw9DuhZEzzsyUoRPC6J7LdC8l6sLx1TlWjJM6CygZlQAlFC\nDce8ElSppVsMPaPz4c2qQA==\n-----END PRIVATE KEY-----\n",
      "client_email": "poc-todo@poc-todo-app-74fe1.iam.gserviceaccount.com",
      "client_id": "111543634509883684127",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/poc-todo%40poc-todo-app-74fe1.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/userinfo.email"
    ];

    Dio dio = Dio();

    final client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();

    prefs?.setString("accessToken", credentials.accessToken.data);
    return credentials.accessToken.data;
  }
}
