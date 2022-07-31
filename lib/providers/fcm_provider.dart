import 'package:flutter_firebase_template/providers/auth_provider.dart';
import 'package:flutter_firebase_template/services/fcm_service.dart';
import 'package:flutter_firebase_template/services/fcm_service_impl.dart';
import 'package:flutter_firebase_template/services/fcm_token_service.dart';
import 'package:flutter_firebase_template/services/fcm_token_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final fcmInitialMessageHandledProvider = StateProvider<bool>((ref) => false);

final fcmTokenServiceProvider = Provider<FcmTokenService?>((ref) {
  final currentUser = ref.watch(authCurrentUserProvider);
  if (currentUser == null) return null;

  return FcmTokenServiceImpl(currentUser: currentUser);
});

final fcmServiceProvider = Provider<FcmService>((ref) {
  final fcmTokenService = ref.watch(fcmTokenServiceProvider);
  final fcmInitialMessageHandled =
      ref.watch(fcmInitialMessageHandledProvider.notifier);
  final fcmService = FcmServiceImpl(fcmTokenService, fcmInitialMessageHandled);

  // If the provider is disposed, we call fcm service dispose,
  // which stops listening to notifications.
  ref.onDispose(() => fcmService.dispose());
  return fcmService;
}, name: "fcm_service_provider");
