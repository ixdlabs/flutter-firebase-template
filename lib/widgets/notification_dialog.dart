import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase_template/logger/logger.dart';

abstract class NotificationDialog {
  final GlobalKey<NavigatorState> navigatorKey;

  NotificationDialog({required this.navigatorKey});

  void showLocalNotification({
    required VoidCallback onTap,
    String? title,
    String? body,
    Map<String, dynamic>? data,
  }) {
    final context = navigatorKey.currentState?.context;
    if (context == null) {
      Log.e('Navigator context is null.');
      return;
    }
    showDialog(context, title: title, body: body, onTap: onTap);
  }

  void showDialog(
    BuildContext context, {
    required VoidCallback onTap,
    String? title,
    String? body,
    Map<String, dynamic>? data,
  });
}

class IosNotificationDialog extends NotificationDialog {
  IosNotificationDialog({required super.navigatorKey});

  @override
  void showDialog(
    BuildContext context, {
    required VoidCallback onTap,
    String? title,
    String? body,
    Map<String, dynamic>? data,
  }) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? "Notification"),
        content: Text(body ?? "You have a notification"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text("Ok"),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              onTap();
            },
          )
        ],
      ),
    );
  }
}
