import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<String?> getFcmToken() async {
  if (Platform.isIOS) {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken;
  }
  String? fcmToken = await FirebaseMessaging.instance.getToken();
  return fcmToken;
}
