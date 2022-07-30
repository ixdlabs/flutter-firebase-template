import 'package:flutter_firebase_template/logger/logger.dart';

abstract class FcmHandler {
  String get name;

  Future<bool> handleNotification(Map<String, dynamic> notificationData);
}

abstract class FcmService {
  final List<FcmHandler> handlers;

  FcmService({required this.handlers});

  void initialize();

  void dispose();

  Future<void> handleNotification(Map<String, dynamic> notificationData) async {
    for (final handler in handlers) {
      try {
        final handled = await handler.handleNotification(notificationData);
        if (handled) {
          Log.i('Notification handled by ${handler.name}: $notificationData');
          return;
        }
      } catch (e, st) {
        Log.e('Error [${handler.name}] handling notification data', e, st);
      }
    }
    Log.w('No handler handled notification data: $notificationData');
  }
}
