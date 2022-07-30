import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_template/providers/auth_provider.dart';
import 'package:flutter_firebase_template/services/fcm_service.dart';
import 'package:flutter_firebase_template/services/fcm_service_impl.dart';
import 'package:flutter_firebase_template/services/fcm_token_service.dart';
import 'package:flutter_firebase_template/services/fcm_token_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final fcmTokenServiceProvider = Provider<FcmTokenService?>((ref) {
  final currentUser = ref.watch(authCurrentUserProvider);
  if (currentUser == null) return null;
  return FcmTokenServiceImpl(
    collectionRef: FirebaseFirestore.instance.collection("fcmTokens"),
    currentUser: currentUser,
  );
});

final fcmServiceProvider = Provider<FcmService>((ref) {
  final fcmTokenService = ref.watch(fcmTokenServiceProvider);
  final fcmService = FcmServiceImpl(fcmTokenService);

  // If the provider is disposed, we call fcm service dispose,
  // which stops listening to notifications.
  ref.onDispose(() => fcmService.dispose());
  return fcmService;
}, name: "fcm_service_provider");
