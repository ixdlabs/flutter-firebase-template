import 'package:flutter_firebase_template/logger/logger.dart';

abstract class FcmHandler {
  String get name;

  Future<bool> handleMessage(Map<String, dynamic> messageData);
}

abstract class FcmService {
  final List<FcmHandler> handlers;

  FcmService({required this.handlers});

  void initialize();

  void dispose();

  Future<void> handleMessage(Map<String, dynamic> messageData) async {
    for (final handler in handlers) {
      try {
        final handled = await handler.handleMessage(messageData);
        if (handled) {
          Log.i('Message handled by ${handler.name}: $messageData');
          return;
        }
      } catch (e, st) {
        Log.e('Error [${handler.name}] handling message data', e, st);
      }
    }
    Log.w('No handler handled message data: $messageData');
  }
}
