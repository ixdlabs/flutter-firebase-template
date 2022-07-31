import 'package:flutter/material.dart';

abstract class DebugConstants {
  static const bool enableEmulators = false;
  static const String emulatorHost = "10.0.2.2";
  static const int emulatorAuthPort = 9099;
  static const int emulatorFirestorePort = 8080;
}

abstract class ColorConstants {
  static const MaterialColor kPrimarySwatch = Colors.blue;
}

abstract class CollectionNames {
  static const String fcmTokens = "fcmTokens";
  static const String counts = "counts";
}

abstract class RemoteConfigKeys {
  static const String minimumAppVersion = "minimumAppVersion";
}
