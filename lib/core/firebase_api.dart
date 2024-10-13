import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:todo_list_poc_task/core/utils/local_notification_service.dart';
import 'package:todo_list_poc_task/core/utils/preference_keys.dart';

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

  Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "poc-todo-app-74fe1",
      "private_key_id": "1a6dbc8c31c8120bc8e19a7ccad635665f6dd9dd",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDhqrQkdwBdzr5b\n2cgszc3bEe2pfSpaNj1hoiIPjE5BvGdtg3R69M9gZGxgaVqq7lX4V4Gwz1UPEUQ4\n+RE8ljb3kRXTViCenX34wh4RKNoieDhNSmicI6cPSgwjccEji20zsfyrfOgAXVfV\nDz5n2GnafblRsCRIu2RNEpWRJRyE2+dobk/Si80m7fu5W6T0LN80bhCyqVY7jD6d\n7vjMhM1itejm13OKcUuEAeX22+Ko7mujBUvsAAfcVn3V9XZe7Ti0Q0q/Bq6gwWOO\njYUe0CBskiyUpVsnh5Ne9Kmyl3Q8FWJciByH1um2Q+rbiFLwB+KRO0ozPSa7DcL8\nEBbeOatvAgMBAAECggEAbRCNg9onyS60fbvhrRXCWhBuJq4hm/v+6oLrp0wOPmMK\nMbmIwCw1VcbzQh1o/pe14RKZ0ZRC7cdQi6CEnh2Tb08ll0BW/5HqYiGfWne+BU7J\nF0HRETWB9je5ah/+Uml+W6+4CEGT9ykl3AlEBfhoIHsG594TiztWHJHQy5d+Ew80\nZ0FKqFxCztCe8Q/def0LkfUA+MljIEsaH5PFuWNEdkzIRe2w3KHjYuVEH1M82PyR\nQgw0ZuxsgXmTc1+i7vINKhtmXIuqrjoem0Yl1WQymuofzYW5GTO/QHLz/1VJbLjq\nuAou+KOjT2RwvEG3MWWuVNixpI1+wvoWAvjrZNsekQKBgQD5k9D556eWrN/WkG9k\npGgNf3ktBXvwY6fX+4NosQPK5sNG/5hAPi6idwGhqbp+wkTqXxS7ntDvDosf3/qL\nQSFOwV4E9cH6jNroZxtCUh2n+HOS0s4IcLJ3nvM+JLHhiiv87nmZqmUvAWeNnaza\nwUIYgk83opSDvHc5YfUrpWtslQKBgQDneV4RWYwjYKpIIGnpO9FA3P3q/A7dC1OL\nvjlo2ag+Gl4jmloPR8bWuc/1YWwaG4JaJFNwevSmaENuR43zKWUSw2pWIQ76cYUI\nnbeZNBozBG6PvOoqhXVtDogqT7Nsj/qyah8SYnE6h0dGwDzqInr7Ohsbl08z/OJG\n9m4l1jqy8wKBgQCmcNe68ayoJZ4Zf7VqDuJ9rfdn+PJQvIUg2tEmLnbzB7ZPUQF+\nRnnfSzJBV+nRw0kmbEZtYVrBMpfBqCN0XvkRho9nC2ZT6z/KIYjiT9ULQfwBfKh+\npHnAoLZjSSF/4h+3zGo3+pUEJhGjNfYi5SNpKO4fkkMtH7D7CcLxWp4riQKBgFcQ\n/MQT5bVs58AHiS70lAoM1emsc77LQtqea6O3syPg8SX9KgDzY6Ri8gj/YxUS4d4c\nKdJ2PU3Wi/6QJaGgIWeEX5wUBTlIt9x8zpFu2qfz885XJdFmr7ucqrUXk4qzQX4Y\nkqVsp+B2/+Vp67+5xn525blkGaOZbFd63AWZZiznAoGAZoHcTezJczq2a1X10CaG\npsbDzIXABMeDRelZT1SasjZP9fLlKe0wb+yAIN3KAUmMrlrnNbkAKK2kIzteMr9N\nRJiOdKesMjoN3KFXcJ82ITCtc4g3ZHX1ZL86uVPwCgC4o2tb54bqiO17aFOhWBrM\nOWLgOfcFj8u39tqMcYrjSAs=\n-----END PRIVATE KEY-----\n",
      "client_email": "poc2-417@poc-todo-app-74fe1.iam.gserviceaccount.com",
      "client_id": "117335487940969535183",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/poc2-417%40poc-todo-app-74fe1.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    final client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();

    await prefs?.setString(
        PreferenceKeys.accessToken, credentials.accessToken.data);
    return credentials.accessToken.data;
  }
}
