import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/services/fcm_service.dart';
import 'package:flutter_firebase_template/widgets/notification_dialog.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FirebaseFcmService extends FcmService {
  final NotificationDialog notificationDialog;

  final StateController<bool> fcmInitialMessageHandled;
  final FirebaseMessaging firebaseMessaging;
  final Stream<RemoteMessage> onMessageStream;
  final Stream<RemoteMessage> onMessageOpenedAppStream;

  final _localChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notifications',
      importance: Importance.max);
  final _localNotificationPlugin = FlutterLocalNotificationsPlugin();
  final _fcmEventStreamController = StreamController<FcmEvent>.broadcast();

  StreamSubscription? _fcmOnMessageOpenedAppSubscription;
  StreamSubscription? _fcmOnMessageSubscription;

  FirebaseFcmService({
    required this.notificationDialog,
    required this.fcmInitialMessageHandled,
    required this.firebaseMessaging,
    required this.onMessageStream,
    required this.onMessageOpenedAppStream,
  });

  @override
  void startListeningToMessages() {
    assert(_fcmOnMessageOpenedAppSubscription == null,
        "Subscription already exists");

    _fcmOnMessageOpenedAppSubscription =
        onMessageOpenedAppStream.listen((message) {
      Log.i("FCM message opened app: $message");
      _fcmEventStreamController.add(FcmEvent(message.data));
    });
    _initializeLocalNotifications();
  }

  /// Initialize Local Notifications.
  /// Make sure to handle the notification if the app was opened by a push notification.
  Future<void> _initializeLocalNotifications() async {
    _localNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_localChannel);
    final initializationSettings = InitializationSettings(
      android: const AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: _iOSShowNotificationWhileOnForeground,
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

  /// If we get a message while the app is in the foreground,
  /// we need to show a notification explicitly.
  /// The reason is FCM will not show notifications for foreground apps.
  /// For this, we pass the notification to the LocalNotificationsPlugin.
  /// If `onMessage` is triggered with a notification, construct our own
  /// local notification to show to users using the created channel.
  void _connectFcmToLocalNotifications() {
    assert(_fcmOnMessageSubscription == null, "Subscription already exists");

    _fcmOnMessageSubscription = onMessageStream.listen((message) {
      Log.i("FCM message received: $message");
      final notification = message.notification;

      if (notification != null) {
        showLocalNotification(
          notification.hashCode,
          title: notification.title,
          body: notification.body,
          data: message.data,
        );
      }
    });
  }

  void _iOSShowNotificationWhileOnForeground(
      int id, String? title, String? body, String? payload) async {
    Log.i("onDidReceiveLocalNotification: $payload");
    notificationDialog.showLocalNotification(
      title: title,
      body: body,
      onTap: () {
        if (payload == null) return;
        final jsonPayload = json.decode(payload);
        if (jsonPayload is Map<String, dynamic>) {
          _fcmEventStreamController.add(FcmEvent(jsonPayload));
        }
      },
    );
  }

  @override
  VoidCallback subscribe(FcmEventHandler handler) {
    final subscription = _fcmEventStreamController.stream.listen(handler);
    _handleInitialMessage();
    return subscription.cancel;
  }

  /// If the app is opened from a notification, we handle it here.
  /// To make sure that we only handle it once, we check if the flag is set.
  void _handleInitialMessage() async {
    if (fcmInitialMessageHandled.state) return;
    Log.d("Handling initial FCM message.");
    final initialMessage = await firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _fcmEventStreamController.add(FcmEvent(initialMessage.data));
    }
    fcmInitialMessageHandled.state = true;
  }

  @override
  void showLocalNotification(int id,
      {String? title, String? body, Map<String, dynamic>? data}) async {
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

  @override
  void stopListeningToMessages() {
    Log.d("FCM service disposed.");
    _fcmOnMessageOpenedAppSubscription?.cancel();
    _fcmOnMessageSubscription?.cancel();
    _fcmEventStreamController.close();
  }

  @override
  String toString() {
    return "FirebaseFcmService()";
  }
}
