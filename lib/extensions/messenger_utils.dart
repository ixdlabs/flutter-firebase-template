import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/extensions/messenger/messenger.dart';
import 'package:flutter_firebase_template/extensions/messenger/snackbar_messenger.dart';

extension MessengerUtils on BuildContext {
  /// Returns the [Messenger] instance.
  Messenger get messenger => SnackBarMessenger(this);
}
