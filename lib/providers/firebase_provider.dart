import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
    (ref) => FirebaseAuth.instance,
    name: "firebase_auth_provider");

final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
    (ref) => FirebaseFirestore.instance,
    name: "firebase_firestore_provider");

final firebaseAnalyticsProvider = Provider<FirebaseAnalytics?>(
    (ref) => FirebaseAnalytics.instance,
    name: "firebase_analytics_provider");

final firebaseCrashlyticsProvider = Provider<FirebaseCrashlytics?>(
    (ref) => FirebaseCrashlytics.instance,
    name: "firebase_crashlytics_provider");
