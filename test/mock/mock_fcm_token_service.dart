import 'dart:async';

import 'package:flutter_firebase_template/services/fcm_token_service.dart';

class MockFcmTokenService extends FcmTokenService {
  @override
  String get collectionName => throw UnimplementedError();

  @override
  void startTokenSync() {}

  @override
  void stopTokenSync() {}

  @override
  Future<void> storeToken(String? token) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
