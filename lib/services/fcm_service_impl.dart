import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/services/fcm_service.dart';
import 'package:flutter_firebase_template/services/fcm_token_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FcmServiceImpl extends FcmService {
  final FcmTokenService? fcmTokenService;
  final StateController<bool> fcmInitialMessageHandled;

  final _localChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notifications',
      importance: Importance.max);
  final _localNotificationPlugin = FlutterLocalNotificationsPlugin();
  final _fcmEventStreamController = StreamController<FcmEvent>.broadcast();

  StreamSubscription? _fcmOnMessageOpenedAppSubscription;
  StreamSubscription? _fcmOnMessageSubscription;
  StreamSubscription? _fcmOnTokenRefreshSubscription;

  FcmServiceImpl(this.fcmTokenService, this.fcmInitialMessageHandled) {
    // Listen to incoming messages.
    _fcmOnMessageOpenedAppSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Log.i("FCM message opened app: $message");
      _fcmEventStreamController.add(FcmEvent(message.data));
    });

    // Store FCM token on firestore.
    // The first token as well as updates are stored in the same collection.
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
    // If the app is opened from a notification, we handle it here.
    // To make sure that we only handle it once, we check if the flag is set.

    if (fcmInitialMessageHandled.state) return;
    Log.d("Handling initial FCM message.");
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _fcmEventStreamController.add(FcmEvent(initialMessage.data));
    }
    fcmInitialMessageHandled.state = true;
  }

  void _storeFcmToken(String? token) {
    if (token == null) return;
    fcmTokenService?.storeToken(token);
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
      // User tapped on the local notification.
      // So wel simply decode the json data and process is the same as FCM.

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
    assert(_fcmOnMessageSubscription == null, "Subscription already exists");

    _fcmOnMessageSubscription = FirebaseMessaging.onMessage.listen((message) {
      // If we get a message while the app is in the foreground,
      // we need to show a notification explicitly.
      // The reason is FCM will not show notifications for foreground apps.
      // For this, we pass the notification to the LocalNotificationsPlugin.
      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.

      Log.i("FCM message received: $message");
      final notification = message.notification;

      if (notification != null) {
        sendSelfNotification(
          notification.hashCode,
          title: notification.title,
          body: notification.body,
          data: message.data,
        );
      }
    });
  }

  @override
  void sendSelfNotification(
    int id, {
    String? title,
    String? body,
    Map<String, dynamic>? data,
  }) async {
    try {
      Log.i("Sending self notification: $title, $body");

      final notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          _localChannel.id,
          _localChannel.name,
          icon: "@mipmap/ic_launcher",
        ),
      );
      _localNotificationPlugin.show(id, title, body, notificationDetails,
          payload: json.encode(data ?? {}));
    } catch (e, st) {
      Log.e('Error sending self notification', e, st);
    }
  }
}
