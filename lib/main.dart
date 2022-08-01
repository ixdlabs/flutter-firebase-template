import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/app.dart';
import 'package:flutter_firebase_template/constants.dart';
import 'package:flutter_firebase_template/firebase_options.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:logger/logger.dart';

void main() async {
  // Don't log anything below warnings in production.
  if (kReleaseMode) Logger.level = Level.warning;
  await Log.initialize();

  // Initialize firebase.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Log.i("Firebase app initialized.");
  // If variable is set, enable firebase emulators.
  if (DebugConstants.enableEmulators) {
    await FirebaseAuth.instance.useAuthEmulator(
        DebugConstants.emulatorHost, DebugConstants.emulatorAuthPort);
    FirebaseFirestore.instance.useFirestoreEmulator(
        DebugConstants.emulatorHost, DebugConstants.emulatorFirestorePort);
    Log.w("Running in emulator mode. Connected to emulators at "
        "${DebugConstants.emulatorHost}.");
  }

  // Remote Config
  await FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    // Set cache expiration to one hour in production.
    minimumFetchInterval: const Duration(minutes: kReleaseMode ? 60 : 1),
  ));
  Log.i("Remote Config initialized.");
  // Crashlytics
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(kReleaseMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  Log.i("Crashlytics initialized.");
  // FCM
  await FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  Log.i("FCM initialized.");

  runApp(const MainAppProvider());
}
