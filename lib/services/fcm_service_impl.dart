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
  final _fcmEventStreamController = StreamController<FcmEvent>();
  late final StreamSubscription<RemoteMessage> _fcmSubscription;

  FcmServiceImpl() {
    // Listen to incoming messages.
    _fcmSubscription = FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _fcmEventStreamController.add(FcmEvent(message.data));
    });
    _initializeLocalNotifications();
  }

  @override
  void dispose() {
    _fcmSubscription.cancel();
    _fcmEventStreamController.close();
  }

  @override
  Stream<FcmEvent> get fcmEventStream => _fcmEventStreamController.stream;

  @override
  void handleInitialMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _fcmEventStreamController.add(FcmEvent(initialMessage.data));
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
    await _localNotificationPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {
      try {
        if (payload == null) return;
        final Map<String, dynamic> notificationData = json.decode(payload);
        _fcmEventStreamController.add(FcmEvent(notificationData));
      } catch (e, st) {
        Log.e('Error handling local notification payload', e, st);
      }
    });
  }
}
