class FcmEvent {
  final Map<String, dynamic> data;

  FcmEvent(this.data);
}

abstract class FcmService {
  /// Handle the notification if the app was opened by a push notification.
  void handleInitialMessage();

  Stream<FcmEvent> get fcmEventStream;

  /// Dispose any resources/connections used by the service.
  void dispose();
}
