import "package:flutter/material.dart";
import 'package:flutter_firebase_template/utils/messenger/messenger.dart';

class SnackBarMessenger extends Messenger {
  SnackBarMessenger(super.context);

  @override
  void showError(String message) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  void showSuccess(String message) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
