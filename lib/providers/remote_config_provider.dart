import 'package:flutter_firebase_template/providers/firebase_provider.dart';
import 'package:flutter_firebase_template/services/remote_config_service.dart';
import 'package:flutter_firebase_template/services/remote_config_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A service provider for remote config.
final remoteConfigProvider = Provider<RemoteConfigService?>((ref) {
  final firebaseRemoteConfig = ref.watch(firebaseRemoteConfigProvider);
  if (firebaseRemoteConfig == null) return null;

  return FirebaseRemoteConfigService(
      firebaseRemoteConfig: firebaseRemoteConfig);
}, name: "remote_config_provider");
