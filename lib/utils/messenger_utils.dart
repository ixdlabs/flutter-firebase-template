import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/utils/messenger/messenger.dart';
import 'package:flutter_firebase_template/utils/messenger/snackbar_messenger.dart';

extension MessengerUtils on BuildContext {
  /// Returns the [Messenger] instance.
  Messenger get messenger => SnackBarMessenger(this);
}
