class FcmEvent {
  final Map<String, dynamic> data;

  FcmEvent(this.data);

  @override
  String toString() => 'FcmEvent{data: $data}';
}

abstract class FcmService {
  /// Handle the notification if the app was opened by a push notification.
  void handleInitialMessage();

  Stream<FcmEvent> get fcmEventStream;

  void sendSelfNotification(
    int id, {
    String? title,
    String? body,
    Map<String, dynamic>? data,
  });

  /// Dispose any resources/connections used by the service.
  void dispose();
}
