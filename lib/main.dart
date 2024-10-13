import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list_poc_task/core/firebase_api.dart';
import 'package:todo_list_poc_task/core/router/router.dart';

import 'core/utils/local_notification_service.dart';
import 'firebase_options.dart';

SharedPreferences? prefs;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  LocalNotification.initialize(flutterLocalNotificationsPlugin);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  await FirebaseApi().getAccessToken();

  final appLinks = AppLinks();

  int? idFromDeepLink;
  final sub = appLinks.uriLinkStream.listen((event) {
    print("ev: ${event.pathSegments}");
    idFromDeepLink = int.tryParse(event.pathSegments.first);
  });
  runApp(MyApp(
    idFromDeepLink: idFromDeepLink,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.idFromDeepLink});

  final int? idFromDeepLink;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Todo App POC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routeInformationParser: goRouter.routeInformationParser,
      routeInformationProvider: goRouter.routeInformationProvider,
      routerDelegate: goRouter.routerDelegate,
    );
  }
}
