import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
    (ref) => FirebaseAuth.instance,
    name: "firebase_auth_provider");

final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
    (ref) => FirebaseFirestore.instance,
    name: "firebase_firestore_provider");

final firebaseSecondaryServicesEnabledProvider = Provider<bool>((ref) => true,
    name: "firebase_secondary_services_enabled_provider");

final firebaseAnalyticsProvider = Provider<FirebaseAnalytics?>((ref) {
  final firebaseSecondaryServicesEnabled =
      ref.watch(firebaseSecondaryServicesEnabledProvider);
  if (!firebaseSecondaryServicesEnabled) return null;

  return FirebaseAnalytics.instance;
}, name: "firebase_analytics_provider");

final firebaseCrashlyticsProvider = Provider<FirebaseCrashlytics?>((ref) {
  final firebaseSecondaryServicesEnabled =
      ref.watch(firebaseSecondaryServicesEnabledProvider);
  if (!firebaseSecondaryServicesEnabled) return null;

  return FirebaseCrashlytics.instance;
}, name: "firebase_crashlytics_provider");

final firebaseRemoteConfigProvider = Provider<FirebaseRemoteConfig?>((ref) {
  final firebaseSecondaryServicesEnabled =
      ref.watch(firebaseSecondaryServicesEnabledProvider);
  if (!firebaseSecondaryServicesEnabled) return null;

  return FirebaseRemoteConfig.instance;
}, name: "firebase_remote_config_provider");

final firebaseMessagingProvider = Provider<FirebaseMessaging?>((ref) {
  final firebaseSecondaryServicesEnabled =
      ref.watch(firebaseSecondaryServicesEnabledProvider);
  if (!firebaseSecondaryServicesEnabled) return null;

  return FirebaseMessaging.instance;
}, name: "firebase_messaging_provider");

final firebaseMessagingOnMessageProvider =
    Provider<Stream<RemoteMessage>?>((ref) {
  final firebaseMessaging = ref.watch(firebaseMessagingProvider);
  if (firebaseMessaging == null) return null;

  return FirebaseMessaging.onMessage;
}, name: "firebase_messaging_on_message_stream_provider");

final firebaseMessagingOnMessageOpenedAppProvider =
    Provider<Stream<RemoteMessage>?>((ref) {
  final firebaseMessaging = ref.watch(firebaseMessagingProvider);
  if (firebaseMessaging == null) return null;

  return FirebaseMessaging.onMessageOpenedApp;
}, name: "firebase_messaging_on_message_opened_app_stream_provider");
