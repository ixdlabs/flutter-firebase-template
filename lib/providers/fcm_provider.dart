import 'package:flutter_firebase_template/services/fcm_service.dart';
import 'package:flutter_firebase_template/services/fcm_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final fcmInitialMessageHandledProvider = StateProvider<bool>((ref) => false,
    name: "fcm_initial_message_handled_provider");

final fcmServiceProvider = Provider<FcmService>((ref) {
  final fcmInitialMessageHandled =
      ref.watch(fcmInitialMessageHandledProvider.notifier);

  final fcmService = FcmServiceImpl(fcmInitialMessageHandled);
  fcmService.startListeningToMessages();
  // If the provider is disposed, we call fcm service dispose,
  // which stops listening to notifications.
  ref.onDispose(() => fcmService.dispose());
  return fcmService;
}, name: "fcm_service_provider");
