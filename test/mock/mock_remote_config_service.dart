import 'dart:async';

import 'package:flutter_firebase_template/services/remote_config_service.dart';

class MockRemoteConfigService extends RemoteConfigService {
  @override
  Future<String> get minimumAppVersion async => "0.0.0";
}
