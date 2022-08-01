import 'package:flutter_firebase_template/services/remote_config_service.dart';
import 'package:flutter_firebase_template/services/remote_config_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final remoteConfigProvider = Provider<RemoteConfigService>((ref) {
  return FirebaseRemoteConfigService();
}, name: "remote_config_provider");
