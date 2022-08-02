import 'dart:ui';

import 'package:flutter_firebase_template/services/fcm_service.dart';

class MockFcmService extends FcmService {
  @override
  void showLocalNotification(int id,
      {String? title, String? body, Map<String, dynamic>? data}) {}

  @override
  void startListeningToMessages() {}

  @override
  void stopListeningToMessages() {}

  @override
  VoidCallback subscribe(FcmEventHandler handler) {
    return () {};
  }
}
