import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> goToSettings({
  required BuildContext context,
  required String title,
  required String content,
  required String buttonTitle,
}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        surfaceTintColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await openAppSettings();
              context.pop();
            },
            style: ElevatedButton.styleFrom(
                surfaceTintColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black)),
            child: Text(
              buttonTitle,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          )
        ],
      );
    },
  );
}
