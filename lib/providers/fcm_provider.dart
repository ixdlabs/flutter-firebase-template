import 'package:flutter_firebase_template/providers/firebase_provider.dart';
import 'package:flutter_firebase_template/services/fcm_service.dart';
import 'package:flutter_firebase_template/services/fcm_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final fcmInitialMessageHandledProvider = StateProvider<bool>((ref) => false,
    name: "fcm_initial_message_handled_provider");

final fcmServiceProvider = Provider<FcmService?>((ref) {
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
    fcmInitialMessageHandled: fcmInitialMessageHandled,
    firebaseMessaging: firebaseMessaging,
    onMessageStream: firebaseMessagingOnMessage,
    onMessageOpenedAppStream: firebaseMessagingOnMessageOpenedApp,
  );
}, name: "fcm_service_provider");
