import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_template/providers/firebase_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A utility provider scope that mocks firebase services.
ProviderScope mockedProviderScope({
  List<Override> overrides = const [],
  required MockFirebaseAuth mockFirebaseAuth,
  required FakeFirebaseFirestore mockFirebaseFirestore,
  required Widget child,
}) {
  return ProviderScope(
    overrides: [
      firebaseAuthProvider.overrideWithValue(mockFirebaseAuth),
      firebaseFirestoreProvider.overrideWithValue(mockFirebaseFirestore),
      // Cannot mock other services for now.
      firebaseSecondaryServicesEnabledProvider.overrideWithValue(false),
      ...overrides
    ],
    child: child,
  );
}
