// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_firebase_template/app.dart';
import 'package:flutter_firebase_template/logger/logger.dart';
import 'package:flutter_firebase_template/providers/fcm_provider.dart';
import 'package:flutter_firebase_template/providers/fcm_token_provider.dart';
import 'package:flutter_firebase_template/providers/firebase_provider.dart';
import 'package:flutter_firebase_template/providers/remote_config_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'mock/mock_fcm_service.dart';
import 'mock/mock_fcm_token_service.dart';
import 'mock/mock_remote_config_service.dart';

void main() {
  setUp(() {
    Log.initialize();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ProviderScope(
      overrides: [
        firebaseAuthProvider.overrideWithValue(MockFirebaseAuth()),
        firebaseFirestoreProvider.overrideWithValue(FakeFirebaseFirestore()),
        firebaseAnalyticsProvider.overrideWithValue(null),
        fcmServiceProvider.overrideWithValue(MockFcmService()),
        fcmTokenServiceProvider.overrideWithValue(MockFcmTokenService()),
        remoteConfigProvider.overrideWithValue(MockRemoteConfigService()),
      ],
      child: const MainApp(),
    ));
  });
}
