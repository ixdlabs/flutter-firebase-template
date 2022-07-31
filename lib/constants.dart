import 'package:flutter/material.dart';

/// Colors used in the app.
abstract class ColorConstants {
  static const MaterialColor kPrimarySwatch = Colors.blue;
}

/// Firestore collection names used in the app.
abstract class CollectionNames {
  static const String fcmTokens = "fcmTokens";
  static const String counts = "counts";
}

/// Keys of Firebase Remote Config used in the app.
abstract class RemoteConfigKeys {
  static const String minimumAppVersion = "minimumAppVersion";
}

/// Misc development constants used in the app.
abstract class DebugConstants {
  static const bool enableEmulators = false;
  static const String emulatorHost = "10.0.2.2";
  static const int emulatorAuthPort = 9099;
  static const int emulatorFirestorePort = 8080;
}
