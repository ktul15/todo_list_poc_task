import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list_poc_task/core/router/path_constants.dart';

import '../../../main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int? idFromDeepLink;
  AppLinks? appLinks;
  StreamSubscription<Uri>? sub;

  @override
  void initState() {
    super.initState();
    appLinks = AppLinks();
    sub = appLinks?.uriLinkStream.listen((event) async {
      print("ev: ${event.pathSegments}");
      idFromDeepLink = int.tryParse(event.pathSegments.first ?? "");
      if (idFromDeepLink != null) {
        print("idFromDeepLink1: $idFromDeepLink");

        prefs?.setString("idFromDeepLink", idFromDeepLink.toString());

        context.pushReplacementNamed(PathConstants.splash);
      }
    });

    Future.delayed(const Duration(seconds: 2), () async {
      await context.pushNamed(PathConstants.todos);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlutterLogo(),
      ),
    );
  }
}
