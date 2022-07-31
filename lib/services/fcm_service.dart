import 'package:flutter/widgets.dart';

typedef FcmEventHandler = void Function(FcmEvent event);

class FcmEvent {
  final Map<String, dynamic> data;

  FcmEvent(this.data);

  @override
  String toString() => 'FcmEvent{data: $data}';
}

abstract class FcmService {
  /// Start listening for incoming messages.
  void startListeningToMessages();

  /// Subscribes to FCM events.
  /// The events will be handled by the provided [handler].
  /// This will return the dispose callback for the [handler].
  VoidCallback subscribe(FcmEventHandler handler);

  /// Sends a notification to self.
  /// Once tapped, this will be handled by the [handler]s provided in [subscribe].
  void showLocalNotification(int id,
      {String? title, String? body, Map<String, dynamic>? data});

  /// Dispose any resources/connections used by the service.
  void stopListeningToMessages();

  /// Starts listening to FCM messages and
  /// returns a callback to stop the listening.
  VoidCallback listenToMessages() {
    startListeningToMessages();
    return () => stopListeningToMessages();
  }
}
