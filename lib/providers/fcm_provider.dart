import 'package:flutter_firebase_template/providers/firebase_provider.dart';
import 'package:flutter_firebase_template/providers/navigator_key_provider.dart';
import 'package:flutter_firebase_template/services/fcm_service.dart';
import 'package:flutter_firebase_template/services/fcm_service_impl.dart';
import 'package:flutter_firebase_template/widgets/notification_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A global state that holds whether the app handled initial FCM tap.
/// This is used to prevent the app from handling the FCM tap several times.
final fcmInitialMessageHandledProvider = StateProvider<bool>((ref) => false,
    name: "fcm_initial_message_handled_provider");

/// FCM service provider.
final fcmServiceProvider = Provider<FcmService?>((ref) {
  final navigatorKey = ref.watch(navigatorKeyProvider);
  final firebaseMessaging = ref.watch(firebaseMessagingProvider);
  final firebaseMessagingOnMessage =
      ref.watch(firebaseMessagingOnMessageProvider);
  final firebaseMessagingOnMessageOpenedApp =
      ref.watch(firebaseMessagingOnMessageOpenedAppProvider);
  if (firebaseMessaging == null ||
      firebaseMessagingOnMessage == null ||
      firebaseMessagingOnMessageOpenedApp == null) {
    return null;
  }

  final fcmInitialMessageHandled =
      ref.watch(fcmInitialMessageHandledProvider.notifier);

  return FirebaseFcmService(
    notificationDialog: IosNotificationDialog(navigatorKey: navigatorKey),
    fcmInitialMessageHandled: fcmInitialMessageHandled,
    firebaseMessaging: firebaseMessaging,
    onMessageStream: firebaseMessagingOnMessage,
    onMessageOpenedAppStream: firebaseMessagingOnMessageOpenedApp,
  );
}, name: "fcm_service_provider");
