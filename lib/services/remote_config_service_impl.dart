import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_firebase_template/constants.dart';
import 'package:flutter_firebase_template/services/remote_config_service.dart';

class FirebaseRemoteConfigService implements RemoteConfigService {
  final FirebaseRemoteConfig firebaseRemoteConfig;

  FirebaseRemoteConfigService({required this.firebaseRemoteConfig});

  @override
  Future<String> get minimumAppVersion async {
    // We can use a separate service to get the minimum app version.
    await firebaseRemoteConfig.fetchAndActivate();
    return firebaseRemoteConfig.getString(RemoteConfigKeys.minimumAppVersion);
  }

  @override
  String toString() {
    return "FirebaseRemoteConfigService()";
  }
}
