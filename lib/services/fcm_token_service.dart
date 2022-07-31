import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/constants.dart';

abstract class FcmTokenService {
  /// Start storing the tokens in cloud.
  /// This will keep listening to the token updates and store them in the cloud.
  void startTokenSync();

  /// Store the token in cloud.
  Future<void> storeToken(String? token);

  /// Dispose any resources/connections used by the service.
  void stopTokenSync();

  VoidCallback tokenSync() {
    startTokenSync();
    return () => stopTokenSync();
  }

  String get collectionName => CollectionNames.fcmTokens;
}
