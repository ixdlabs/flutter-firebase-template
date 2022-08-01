import 'package:flutter_firebase_template/services/fcm_service.dart';
import 'package:flutter_firebase_template/services/fcm_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final fcmInitialMessageHandledProvider = StateProvider<bool>((ref) => false,
    name: "fcm_initial_message_handled_provider");

final fcmServiceProvider = Provider<FcmService>((ref) {
  final fcmInitialMessageHandled =
      ref.watch(fcmInitialMessageHandledProvider.notifier);

  return FirebaseFcmService(fcmInitialMessageHandled);
}, name: "fcm_service_provider");
