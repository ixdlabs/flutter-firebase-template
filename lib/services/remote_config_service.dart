import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_firebase_template/constants.dart';

class RemoteConfigService {
  RemoteConfigService._();

  final _remoteConfig = FirebaseRemoteConfig.instance;
  static final _instance = RemoteConfigService._();

  static RemoteConfigService get instance => _instance;

  Future<String> get minimumAppVersion async {
    // We can use a separate service to get the minimum app version.
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getString(RemoteConfigKeys.minimumAppVersion);
  }
}
