import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

Future<void> manageCameraPermissions({
  required FutureOr<void>? Function() onGrantedCallback,
  required FutureOr<void>? Function() onDeniedCallback,
  required FutureOr<void>? Function() onPermanentlyDeniedCallback,
}) async {
  // manage permission for camera
  await Permission.camera.onDeniedCallback(() async {
    // Your code
    await onDeniedCallback();
  }).onGrantedCallback(() async {
    // Your code
    await onGrantedCallback();
  }).onPermanentlyDeniedCallback(() async {
    // Your code
    await onPermanentlyDeniedCallback();
  }).request();
}
