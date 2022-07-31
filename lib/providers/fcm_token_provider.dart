import 'package:flutter_firebase_template/providers/auth_provider.dart';
import 'package:flutter_firebase_template/services/fcm_token_service.dart';
import 'package:flutter_firebase_template/services/fcm_token_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final fcmTokenServiceProvider = Provider<FcmTokenService?>((ref) {
  final currentUser = ref.watch(authCurrentUserProvider);
  if (currentUser == null) return null;

  final fcmTokenService = FcmTokenServiceImpl(currentUser: currentUser);
  fcmTokenService.startTokenSync();
  // If the provider is disposed, we call fcm token service dispose,
  // which stops listening to token updates.
  ref.onDispose(() => fcmTokenService.dispose());
  return fcmTokenService;
}, name: "fcm_token_service_provider");
