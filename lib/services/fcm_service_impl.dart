import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/services/fcm_service.dart';

class FcmServiceImpl extends FcmService {
  // final _localChannel = AndroidNotificationChannel(
  //   'high_importance_channel',
  //   'High Importance Notifications',
  //   importance: Importance.max,
  // );
  // final _localNotificationPlugin = FlutterLocalNotificationsPlugin();

  FcmServiceImpl({required super.handlers});

  @override
  void initialize() async {
    _initializeFcm();
    _initializeLocalNotifications();
  }

  @override
  void dispose() async {
    // _localNotificationPlugin.cancelAll();
    // FirebaseMessaging().unsubscribeFromTopic('all');
  }

  /// Initialize Firebase Cloud Messaging.
  /// Make sure to handle the notification if the app was opened by a push notification.
  Future<void> _initializeFcm() async {
    // await FirebaseMessaging.instance.requestPermission();
    // await FirebaseMessaging.instance
    //     .setForegroundNotificationPresentationOptions(
    //         alert: true, badge: true, sound: true);
    // FirebaseMessaging.onMessageOpenedApp.listen((notification) {
    //   if (notification == null) return;
    //   handleNotification(notification.data);
    // });
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
    //       handleNotification(notificationData);
    //     } catch (e) {
    //       print(e);
    //     }
    //   },
    // );
  }
}

class DemoFcmHandler extends FcmHandler {
  @override
  Future<bool> handleNotification(Map<String, dynamic> notificationData) async {
    Log.i("Notification data: $notificationData");
    return false;
  }

  @override
  String get name => "demo_fcm_handler";
}
