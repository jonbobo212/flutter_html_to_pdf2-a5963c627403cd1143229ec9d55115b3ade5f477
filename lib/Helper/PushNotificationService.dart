import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/firebase_notification.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Screen/DeshBord/dashboard.dart';
import 'package:sellermultivendor/Screen/HomePage/home.dart';
import 'package:sellermultivendor/Screen/OrderList/order_details_screen.dart';
import 'package:sellermultivendor/Widget/api.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import 'package:sellermultivendor/Widget/routes.dart';
import 'package:sellermultivendor/Widget/sharedPreferances.dart';

class PushNotificationService {
  static const String generalNotificationChannel = 'general_channel';
  static const String chatNotificationChannel = 'chat_channel';
  static const String imageNotificationChannel = 'image_channel';
  PushNotificationService();
  static late BuildContext context;

  static bool initialized = false;

  static final List<NotificationPermission> _requiredPermissionGroup = [
    NotificationPermission.Alert,
    NotificationPermission.Sound,
    NotificationPermission.Badge,
    NotificationPermission.Vibration,
    NotificationPermission.Light
  ];

  static final FirebaseNotificationManager _firebaseNotificationManager =
      FirebaseNotificationManager(
          foregroundMessageHandler: foregroundNotification,
          onTapNotification: onTapNotification);
  static final AwesomeNotifications notification = AwesomeNotifications();

  static void setDeviceToken(
      {bool clearSessionToken = false, SettingProvider? settingProvider}) {
    if (clearSessionToken) {
      settingProvider ??= Provider.of<SettingProvider>(context, listen: false);
    }
    FirebaseMessaging.instance.getToken().then((token) async {
      var parameter = {
        FCMID: token,
        'device_type': Platform.isAndroid ? 'android' : 'ios'
      };
      apiBaseHelper.postAPICall(updateFcmApi, parameter).then(
            (getdata) async {},
            onError: (error) {},
          );
    });
  }

  static void init() async {

    await _firebaseNotificationManager.init();
    await requestPermission();
    _initializeNotificationChannels();
    notification.setListeners(
        onActionReceivedMethod: _awesomeNotificationTapListener);

    initialized = true;
    setDeviceToken();
  }

  static void onMessageOpenedAppListener(
    RemoteMessage remoteMessage,
  ) {
    onTapNotification(remoteMessage.data);
  }

  static void _initializeNotificationChannels() {
    notification.initialize('resource://mipmap/notification', [
      NotificationChannel(
          channelKey: generalNotificationChannel,
          channelName: 'General notifications',
          channelDescription: 'General channel to display notifications',
          importance: NotificationImportance.Max,
          playSound: true),
      NotificationChannel(
          channelKey: chatNotificationChannel,
          channelName: 'Chat Notifications',
          channelDescription: 'To display chat notification',
          importance: NotificationImportance.Max,
          playSound: true),
      NotificationChannel(
        channelKey: imageNotificationChannel,
        channelName: 'Image Notifications',
        channelDescription: 'To display images as notifications',
        importance: NotificationImportance.Max,
        playSound: true,
      )
    ]);
  }

  @pragma("vm:entry-point")
  static Future<void> _awesomeNotificationTapListener(
      ReceivedAction action) async {
    log('Action is a ${action}');
    onTapNotification(action.payload ?? {});
  }

  static Future<void> requestPermission() async {
    final NotificationSettings settings =
        await FirebaseMessaging.instance.getNotificationSettings();

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      await notification.requestPermissionToSendNotifications(
          channelKey: generalNotificationChannel,
          permissions: _requiredPermissionGroup);
      await notification.requestPermissionToSendNotifications(
          channelKey: chatNotificationChannel,
          permissions: _requiredPermissionGroup);
      await notification.requestPermissionToSendNotifications(
          channelKey: imageNotificationChannel,
          permissions: _requiredPermissionGroup);
    }
  }

  static Future<void> createGeneralNotification(
      {String? title, String? body, Map<String, String>? payload}) async {
    if (!Platform.isIOS) {
      await notification.createNotification(
          content: NotificationContent(
              id: 0,
              channelKey: generalNotificationChannel,
              title: title,
              body: body,
              payload: payload ?? {},
              wakeUpScreen: true));
    }
  }

  static Future<void> createImageNotification({
    String? title,
    String? body,
    Map<String, String>? payload,
  }) async {
    if (!Platform.isIOS) {
      await notification.createNotification(
        content: NotificationContent(
            id: 0,
            channelKey: imageNotificationChannel,
            title: title,
            body: body,
            wakeUpScreen: true,
            largeIcon: payload?['image'],
            hideLargeIconOnExpand: true,
            notificationLayout: NotificationLayout.BigPicture,
            bigPicture: payload?['image'],
            payload: payload),
      );
    }
  }

  static Future<void> createChatNotification({
    String? title,
    String? body,
    Map<String, String>? payload,
  }) async {
    if (!Platform.isIOS) {
      await notification.createNotification(
        content: NotificationContent(
            id: 0,
            channelKey: chatNotificationChannel,
            title: title,
            body: body,
            wakeUpScreen: true,
            largeIcon: payload?['image'],
            hideLargeIconOnExpand: true,
            notificationLayout: NotificationLayout.BigPicture,
            bigPicture: payload?['image'],
            payload: payload),
      );
    }
  }

  static Future<void> foregroundNotification(RemoteMessage notification) async {
    handleNotification(notification);
  }

  @pragma("vm:entry-point")
  static Future<void> backgroundNotification(RemoteMessage notification) async {
    handleBackgroundMessage(notification);
    setPrefrenceBool(iSFROMBACK, true);
  }

  static Future<void> handleNotification(RemoteMessage notification) async {
    handleBackgroundMessage(notification);
  }

  static void onTapNotification(Map<String, dynamic> data) async {
    _navigation(Map<String, String>.from(data));
    setPrefrenceBool(iSFROMBACK, false);
  }

  static void handleBackgroundMessage(RemoteMessage notification) {
    print(notification.data);
    var image = notification.data['image'] ?? '';
    if (image != null && image != 'null' && image != '') {
      createImageNotification(
          body: notification.data['body'],
          title: notification.data['title'],
          payload: Map<String, String>.from(notification.data));
    } else {
      createGeneralNotification(
        title: notification.data['title'],
        body: notification.data['body'],
      );
    }
  }

  static _navigation(Map<String, String> data) async {
    var orderId = data['order_id'] ?? '';
    if (orderId != '') {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => OrderDetailsScreen(
            id: orderId,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => const Dashboard()),
      );
    }
  }
}
