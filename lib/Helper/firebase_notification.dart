

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sellermultivendor/Helper/PushNotificationService.dart';

class FirebaseNotificationManager {
  final Future<void> Function(RemoteMessage message)? foregroundMessageHandler;
  final void Function(Map<String, dynamic> payload)? onTapNotification;
  FirebaseNotificationManager({
    this.foregroundMessageHandler,
    this.onTapNotification,
  });

  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(
        PushNotificationService.backgroundNotification);

    RemoteMessage? value = await FirebaseMessaging.instance.getInitialMessage();
    if (value != null) {
      onTapNotification?.call(value.data);
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      foregroundMessageHandler?.call(event);
    });

    //This will listen onTap so we are making it external function so we can manage taps from one method of awesome and local notification
    FirebaseMessaging.onMessageOpenedApp
        .listen((event) => onTapNotification?.call(event.data));
  }
}
