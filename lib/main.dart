import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/app.dart';
import 'package:flutter_firebase_template/constants.dart';
import 'package:flutter_firebase_template/firebase_options_example.dart';
import 'package:flutter_firebase_template/logger/logger.dart';

void main() async {
  await Log.initialize();

  // Initialize firebase.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  final firebaseRemoteConfig = FirebaseRemoteConfig.instance;
  final firebaseCrashlytics = FirebaseCrashlytics.instance;
  final firebaseMessaging = FirebaseMessaging.instance;
  final firebaseAnalytics = FirebaseAnalytics.instance;
  Log.setFirebaseServices(
    crashlytics: firebaseCrashlytics,
    analytics: firebaseAnalytics,
  );
  Log.i("Firebase app initialized.");

  // If variable is set, enable firebase emulators.
  if (DebugConstants.enableEmulators) {
    await firebaseAuth.useAuthEmulator(
        DebugConstants.emulatorHost, DebugConstants.emulatorAuthPort);
    firebaseFirestore.useFirestoreEmulator(
        DebugConstants.emulatorHost, DebugConstants.emulatorFirestorePort);
    Log.w("Running in emulator mode. Connected to emulators at "
        "${DebugConstants.emulatorHost}.");
  }

  // Remote Config
  await firebaseRemoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    // Set cache expiration to one hour in production.
    minimumFetchInterval: const Duration(minutes: kReleaseMode ? 60 : 1),
  ));
  Log.i("Remote Config initialized.");
  // Crashlytics
  await firebaseCrashlytics.setCrashlyticsCollectionEnabled(kReleaseMode);
  FlutterError.onError = firebaseCrashlytics.recordFlutterError;
  Log.i("Crashlytics initialized.");
  // FCM
  await firebaseMessaging.requestPermission();
  await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  Log.i("FCM initialized.");

  runApp(const MainAppProvider());
}
