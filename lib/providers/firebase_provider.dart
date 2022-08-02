import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Firebase Authentication Provider.
final firebaseAuthProvider = Provider<FirebaseAuth>(
    (ref) => FirebaseAuth.instance,
    name: "firebase_auth_provider");

/// Firebase Firestore Provider.
final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
    (ref) => FirebaseFirestore.instance,
    name: "firebase_firestore_provider");

/// Provider that indicates whether other firebase services are enabled or not.
/// If this is false, other providers and any providers that depend on them
/// will return null.
final firebaseSecondaryServicesEnabledProvider = Provider<bool>((ref) => true,
    name: "firebase_secondary_services_enabled_provider");

/// Firebase Analytics Provider.
final firebaseAnalyticsProvider = Provider<FirebaseAnalytics?>((ref) {
  final firebaseSecondaryServicesEnabled =
      ref.watch(firebaseSecondaryServicesEnabledProvider);
  if (!firebaseSecondaryServicesEnabled) return null;

  return FirebaseAnalytics.instance;
}, name: "firebase_analytics_provider");

/// Firebase Crashlytics Provider.
final firebaseCrashlyticsProvider = Provider<FirebaseCrashlytics?>((ref) {
  final firebaseSecondaryServicesEnabled =
      ref.watch(firebaseSecondaryServicesEnabledProvider);
  if (!firebaseSecondaryServicesEnabled) return null;

  return FirebaseCrashlytics.instance;
}, name: "firebase_crashlytics_provider");

/// Firebase Remote Config Provider.
final firebaseRemoteConfigProvider = Provider<FirebaseRemoteConfig?>((ref) {
  final firebaseSecondaryServicesEnabled =
      ref.watch(firebaseSecondaryServicesEnabledProvider);
  if (!firebaseSecondaryServicesEnabled) return null;

  return FirebaseRemoteConfig.instance;
}, name: "firebase_remote_config_provider");

/// Firebase Messaging Provider.
final firebaseMessagingProvider = Provider<FirebaseMessaging?>((ref) {
  final firebaseSecondaryServicesEnabled =
      ref.watch(firebaseSecondaryServicesEnabledProvider);
  if (!firebaseSecondaryServicesEnabled) return null;

  return FirebaseMessaging.instance;
}, name: "firebase_messaging_provider");

/// Provider for firebase messaging on message stream.
/// This is only available if firebase messaging is available.
final firebaseMessagingOnMessageProvider =
    Provider<Stream<RemoteMessage>?>((ref) {
  final firebaseMessaging = ref.watch(firebaseMessagingProvider);
  if (firebaseMessaging == null) return null;

  return FirebaseMessaging.onMessage;
}, name: "firebase_messaging_on_message_stream_provider");

/// Provider for firebase messaging on messages that opened app stream.
/// This is only available if firebase messaging is available.
final firebaseMessagingOnMessageOpenedAppProvider =
    Provider<Stream<RemoteMessage>?>((ref) {
  final firebaseMessaging = ref.watch(firebaseMessagingProvider);
  if (firebaseMessaging == null) return null;

  return FirebaseMessaging.onMessageOpenedApp;
}, name: "firebase_messaging_on_message_opened_app_stream_provider");
