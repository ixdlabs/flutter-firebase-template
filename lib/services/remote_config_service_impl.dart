import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_firebase_template/constants.dart';
import 'package:flutter_firebase_template/services/remote_config_service.dart';

class FirebaseRemoteConfigService implements RemoteConfigService {
  final _remoteConfig = FirebaseRemoteConfig.instance;

  @override
  Future<String> get minimumAppVersion async {
    // We can use a separate service to get the minimum app version.
    await _remoteConfig.fetchAndActivate();
    return _remoteConfig.getString(RemoteConfigKeys.minimumAppVersion);
  }
}
