import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/services/fcm_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FcmServiceImpl extends FcmService {
  final _localChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notifications',
      importance: Importance.max);
  final _localNotificationPlugin = FlutterLocalNotificationsPlugin();
  late final StreamSubscription _fcmSubscription;

  FcmServiceImpl({required super.handlers});

  @override
  void initialize() {
    _initializeFcm();
    _initializeLocalNotifications();
  }

  @override
  void dispose() {
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
    _localNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_localChannel);
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      ),
    );
    await _localNotificationPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        try {
          if (payload == null) return;
          final notificationData = json.decode(payload);
          handleMessage(notificationData);
        } catch (e, st) {
          Log.e('Error handling local notification payload', e, st);
        }
      },
    );
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
