import 'package:flutter_firebase_template/providers/auth_provider.dart';
import 'package:flutter_firebase_template/services/fcm_token_service.dart';
import 'package:flutter_firebase_template/services/fcm_token_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final fcmTokenServiceProvider = Provider<FcmTokenService?>((ref) {
  final currentUser = ref.watch(authCurrentUserProvider);
  if (currentUser == null) return null;

  return FcmTokenServiceImpl(currentUser: currentUser);
}, name: "fcm_token_service_provider");
