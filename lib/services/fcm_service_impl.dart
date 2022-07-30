import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/services/fcm_service.dart';

class FcmServiceImpl extends FcmService {
  // final _localChannel = AndroidNotificationChannel(
  //   'high_importance_channel',
  //   'High Importance Notifications',
  //   importance: Importance.max,
  // );
  // final _localNotificationPlugin = FlutterLocalNotificationsPlugin();
  late final StreamSubscription _fcmSubscription;

  FcmServiceImpl({required super.handlers});

  @override
  void initialize() {
    _initializeFcm();
    _initializeLocalNotifications();
  }

  @override
  void dispose() {
    // _localNotificationPlugin.cancelAll();
    _fcmSubscription.cancel();
  }

  /// Initialize Firebase Cloud Messaging.
  Future<void> _initializeFcm() async {
    // Listen to incoming messages.
    _fcmSubscription = FirebaseMessaging.onMessageOpenedApp
        .listen((message) => handleMessage(message.data));

    /// Make sure to handle the notification if the app was opened by a push notification.
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(initialMessage.data);
    }
  }

  /// Initialize Local Notifications.
  /// Make sure to handle the notification if the app was opened by a push notification.
  /// TODO: https://pub.dev/packages/flutter_local_notifications#release-build-configuration
  Future<void> _initializeLocalNotifications() async {
    // _localNotificationPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.createNotificationChannel(_localChannel);
    // final initializationSettings = InitializationSettings(
    //   android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    //   iOS: IOSInitializationSettings(
    //     requestSoundPermission: true,
    //     requestBadgePermission: true,
    //     requestAlertPermission: true,
    //   ),
    // );
    // await _localNotificationPlugin.initialize(
    //   initializationSettings,
    //   onSelectNotification: (payload) async {
    //     try {
    //       final notificationData = json.decode(payload);
    //       handleMessage(notificationData);
    //     } catch (e) {
    //       print(e);
    //     }
    //   },
    // );
  }
}

class DemoFcmHandler extends FcmHandler {
  @override
  Future<bool> handleMessage(Map<String, dynamic> messageData) async {
    Log.i("Message data: $messageData");
    return false;
  }

  @override
  String get name => "demo_fcm_handler";
}
