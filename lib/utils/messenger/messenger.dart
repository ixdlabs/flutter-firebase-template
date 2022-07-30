import "package:flutter/material.dart";
import 'package:flutter_firebase_template/utils/messenger/messenger_impl.dart';

abstract class Messenger {
  final BuildContext context;

  Messenger(this.context);

  void showError(String message);

  void showSuccess(String message);

  static Messenger of(BuildContext context) {
    return SnackBarMessenger(context);
  }
}
