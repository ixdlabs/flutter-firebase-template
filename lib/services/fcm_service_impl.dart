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
  final _fcmEventStreamController = StreamController<FcmEvent>.broadcast();

  StreamSubscription? _fcmOnMessageOpenedAppSubscription;
  StreamSubscription? _fcmOnMessageSubscription;
  StreamSubscription? _fcmOnTokenRefreshSubscription;

  FcmServiceImpl() {
    // Listen to incoming messages.
    _fcmOnMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Log.i("FCM message opened app: $message");
      _fcmEventStreamController.add(FcmEvent(message.data));
    });

    FirebaseMessaging.instance.getToken().then(_storeFcmToken);
    _fcmOnTokenRefreshSubscription =
        FirebaseMessaging.instance.onTokenRefresh.listen(_storeFcmToken);
    _initializeLocalNotifications();
  }

  @override
  void dispose() {
    Log.d("FCM service disposed.");
    _fcmOnMessageOpenedAppSubscription?.cancel();
    _fcmOnTokenRefreshSubscription?.cancel();
    _fcmOnMessageSubscription?.cancel();
    _fcmEventStreamController.close();
  }

  @override
  Stream<FcmEvent> get fcmEventStream => _fcmEventStreamController.stream;

  @override
  void handleInitialMessage() async {
    Log.d("Handling initial FCM message.");
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _fcmEventStreamController.add(FcmEvent(initialMessage.data));
    }
  }

  void _storeFcmToken(String? token) {
    if (token == null) return;
    Log.i("Storing FCM token: $token");
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
      Log.i("Local notification selected: $payload");
      try {
        if (payload == null) return;
        final Map<String, dynamic> notificationData = json.decode(payload);
        _fcmEventStreamController.add(FcmEvent(notificationData));
      } catch (e, st) {
        Log.e('Error handling local notification payload', e, st);
      }
    });

    _connectFcmToLocalNotifications();
  }

  void _connectFcmToLocalNotifications() {
    assert(
        _fcmOnMessageSubscription == null, "FCM subscription already exists");

    _fcmOnMessageSubscription = FirebaseMessaging.onMessage.listen((message) {
      Log.i("FCM message received: $message");
      final notification = message.notification;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      // We dont send a local notification if the notification is for new messages.
      if (notification != null) {
        _localNotificationPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _localChannel.id,
              _localChannel.name,
              icon: "@mipmap/ic_launcher",
            ),
          ),
          payload: json.encode(message.data),
        );
      }
    });
  }

  @override
  void sendSelfNotification(String title, String body) async {
    try {
      Log.i("Sending self notification: $title, $body");

      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          _localChannel.id,
          _localChannel.name,
          importance: _localChannel.importance,
        ),
        iOS: const IOSNotificationDetails(),
      );
      await _localNotificationPlugin.show(0, title, body, notificationDetails,
          payload: '{}');
    } catch (e, st) {
      Log.e('Error sending self notification', e, st);
    }
  }
}
